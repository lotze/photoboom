class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :presence => true

  def self.find_or_create(auth_hash)
    unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      if auth_hash["info"]["email"]
        user = User.find_by(email: auth_hash["info"]["email"])
      end
      unless user
        name = auth_hash["info"]["name"] || auth_hash["info"]["email"]
        if name == auth_hash["info"]["email"]
          name = name.sub(/@.*/, '')
        end
        user = User.create :name => name,
                           :email => auth_hash["info"]["email"]
      end
      auth = create :user => user,
                    :provider => auth_hash["provider"],
                    :uid => auth_hash["uid"]
    end

    return auth
  end
end
