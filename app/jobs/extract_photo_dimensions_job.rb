class ExtractPhotoDimensionsJob < ApplicationJob
  queue_as :default

  def perform(photo)
    photo.update_dimensions
  end
end
