class StripeWebhooksController < ApplicationController
  skip_before_action :identify_user
  skip_before_action :enforce_login
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.headers['Stripe-Signature']

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET'])
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      return head :bad_request
    end

    if event['type'] == 'checkout.session.completed'
      session = event['data']['object']
      payment = Payment.find_by(stripe_checkout_session_id: session['id']) ||
                Payment.find_by(id: session['metadata']['payment_id'])

      if payment
        payment.update!(
          status: 'completed',
          stripe_payment_intent_id: session['payment_intent'],
        )
        payment.game.update!(
          tier: payment.tier,
          launched_at: Time.current,
          stripe_checkout_session_id: session['id'],
        )
      end
    end

    head :ok
  end
end
