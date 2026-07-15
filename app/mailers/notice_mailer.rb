class NoticeMailer < ApplicationMailer
  def photo_error(photo)
    @photo = photo
    @mission = @photo.mission
    mail(to: @photo.user.email,
         subject: "Error with uploaded photo for #{@mission.name}")
  end

  def rejected_photo(photo, notes)
    @photo = photo
    @notes = notes
    mail(to: photo.user.email,
         from: ENV['ADMIN_EMAIL'],
         subject: "Photo for #{photo.mission} was rejected")
  end

  def unrejected_photo(photo, notes)
    @photo = photo
    @notes = notes
    mail(to: photo.user.email,
         from: ENV['ADMIN_EMAIL'],
         subject: "Photo for #{photo.mission} was accepted")
  end

  def game_finished(game, user)
    @game = game
    mail(to: user.email,
         from: ENV['ADMIN_EMAIL'],
         subject: "#{@game.name} has ended - download your photos!")
  end
end