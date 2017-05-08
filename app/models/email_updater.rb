require 'net/imap'
require 'mail'

class EmailUpdater
  def get_with_imap(gmail_login, gmail_password)
    imap = Net::IMAP.new("imap.gmail.com",993,true)
    imap.login(gmail_login, gmail_password)
    imap.select('INBOX')
    imap.search(["NOT", "SEEN"]).each do |message_id|
      msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      message = Mail.new(msg)
      email = message.from.length > 0 ? message.from.try(:first) : mission.from.to_s
      subject = message.subject
      ts = message.date
      body = message.multipart? ? (message.text_part ? message.text_part.body.decoded : nil) : message.body.decoded

      yield email, ts, subject, body, message.attachments
      
      if Rails.env.development?
        # for testing, mark as unseen
        imap.store(message_id, "-FLAGS", [:Seen])
      else
        # mark as seen (should be done automatically, but just in case)
        imap.store(message_id, "+FLAGS", [:Seen])
      end
    end
    begin
      imap.logout()
      imap.disconnect() 
    rescue Exception => e
    end
  end

  def update
    gmail_login = ENV['GMAIL_LOGIN']
    gmail_password = ENV['GMAIL_PASSWORD']

    get_with_imap(gmail_login, gmail_password) do |email, ts, subject, body, attachments|
      # identify game (just default Game)
      game = Game.default_game

      # find user
      user = User.find_by(email: email)
      unless user
        # if no user, create
        user = User.create(email: email, name: email.sub(/@.*/, ''))
        # email organizer to notify
        begin
          NoticeMailer.new_user(user, game).deliver_now
        rescue => e
          Rails.logger.warn("Could not email for new user #{user}/#{subject}: #{e}")
        end
      end

      # identify team
      team = User.team
      unless team
        begin
          NoticeMailer.missing_team(user, game).deliver_now
        rescue => e
          Rails.logger.warn("Could not email for missing team #{user}/#{subject}: #{e}")
        end
      end

      # identify mission
      mission_id = subject[/\d+/]
      mission = Mission.find_by(priority: mission_id)
      # if cannot identify mission, email sender and organizer with error
      if !misson
        begin
          NoticeMailer.missing_mission(user, game, subject).deliver_now
        rescue => e
          Rails.logger.warn("Could not email for missing mission #{user}/#{subject}: #{e}")
        end
      else
        # extract photos
        images = attachments.find_all {|a| a.content_type =~ /^image\//i}
        photos = []
        begin
          photos = images.map do |attachment|
            # create new photo for this user/mission
            image_file = StringIO.new(attachment.decoded)
            class << image_file
              attr_accessor :original_filename, :content_type
            end
            image_file.original_filename = attachment.filename
            image_file.content_type = attachment.content_type
            Photo.create(user: user, game: game, mission: mission, photo: image_file, notes: body[0..255])
            # # in case that starts failing, code to write to tmp file and then store
            # random_filename = "photo_#{Time.now.to_i}_#{rand(5000)}"
            # tmp_file = File.new(random_filename, "wb")
            # tmp_file.write(attachment.decoded)
            # tmp_file.close
            # Photo.create(user: user, game: game, mission: mission, photo: File.open(tmp_file, 'r'), notes: body[0..255])
          end
        rescue => e
          Rails.logger.warn("Error processing photos for #{user}/#{subject}: #{e}")
        end

        # check to see if we got photos
        if photos.length > 0
          # success, email sender :)
          begin
            NoticeMailer.photo_received(user, game, mission, subject).deliver_now
          rescue => e
            Rails.logger.warn("Could not email for successful photo #{user}/#{subject}: #{e}")
          end
        else
          # if no photo, email sender and organizer with error
          begin
            NoticeMailer.no_photos_received(user, game, mission, subject).deliver_now
          rescue => e
            Rails.logger.warn("Could not email for missing photos #{user}/#{subject}: #{e}")
          end
        end
      end
    end
  end
end
