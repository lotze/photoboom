class GameFinisher < ActiveJob::Base
  queue_as :default
  def perform(game_id)
    game = Game.find(game_id)
    if (game.ends_at < Time.now) && !(game.zip_file.attached?)
      game.make_zip_file
      game.users.each do |user|
        NoticeMailer.game_finished(game, user).deliver_later
      end
    end
  end
end
