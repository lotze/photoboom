class PhotoProcessor< ActiveJob::Base
  queue_as :photo_processor
  include ActiveJob::Retry.new(strategy: :variable,
                               delays: [5.seconds, 1.minutes])

  def perform(photo_params)
    photo_params[:submitted_at] = Time.parse(photo_params[:submitted_at])

    image_file = File.open(photo_params.delete(:tmp_file))
    class << image_file
      attr_accessor :original_filename, :content_type
    end
    image_file.original_filename = photo_params.delete(:original_filename)
    image_file.content_type = photo_params.delete(:content_type)

    @photo = Photo.new(photo_params.merge(photo: image_file))
    if @photo.save
      if !Rails.env.development? && @photo.submitted_at > @photo.game.ends_at + 2.minutes # 2 minute grace period
        @photo.reject!('The game has ended!')
      end
    else
      Rails.logger.error("Error uploading photo: #{@photo.errors}")
      # TODO: send email to uploader
    end
  end
end