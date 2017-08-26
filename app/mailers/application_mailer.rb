class ApplicationMailer < ActionMailer::Base
  default from: ENV['PHOTO_SUBMIT_EMAIL'] || ENV['GMAIL_LOGIN']
  layout 'mailer'
end
