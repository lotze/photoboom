class NoticeMailer < ApplicationMailer
  def new_user(user, game)
    @user = user
    mail(to: game.organizer.email,
         subject: "New user email #{user.email}")
  end

  def missing_team(user, game)
    @user = user
    @game = game
    mail(to: game.organizer.email,
         subject: "Missing team for #{user.email}")
  end

  def missing_mission(user, game, subject)
    @subject = subject
    mail(to: [user.email, game.organizer.email],
         subject: "Missing mission number! (was Re: #{subject})")
  end

  def photo_error(photo)
    @photo = photo
    @mission = @photo.mission
    mail(to: @photo.user.email,
         subject: "Error with uploaded photo for #{@mission.name}")
  end

  def photos_received(user, game, mission, subject)
    @mission = mission
    mail(to: user.email,
         subject: subject)
  end

  def no_photos_received(user, game, mission, subject)
    mail(to: [user.email, game.organizer.email],
         subject: "Missing photos! (was Re: #{subject})")
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
end