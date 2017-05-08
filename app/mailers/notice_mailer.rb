class NoticeMailer < ApplicationMailer
  def new_user(user, game)
    @user = user
    mail(to: game.organizer.email,
         subject: "New user email #{user.email}")
  end

  def missing_team(user, game)
    @user = user
    @game = game
    mail(to: @game.organizer.email,
         subject: "Missing team for #{user.email}")
  end

  def missing_mission(user, game, subject)
    mail(to: [@user.email, game.organizer.email],
         subject: "Missing mission number! (was Re: #{subject})")
  end

  def photos_received(user, game, mission, subject)
    mail(to: @user.email,
         subject: "Re: #{subject}")
  end

  def no_photos_received(user, game, mission, subject)
    mail(to: [@user.email, game.organizer.email],
         subject: "Missing photos! (was Re: #{subject})")
  end

  def rejected_photo(photo, notes)
    @photo = photo
    @notes = notes
    mail(to: photo.user.email,
         subject: "Photo for #{photo.mission} was rejected")
  end
end