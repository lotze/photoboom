class GameFinisher < ActiveJob::Base
  queue_as :default
  def perform(game_id)
    game = Game.find(game_id)
    if (game.ends_at < Time.now) && !(game.zip_file?)
      game.make_zip_file
    end
  end
end
