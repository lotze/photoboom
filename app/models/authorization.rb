class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :provider, :uid, :presence => true

  def self.find_or_create(auth_hash)
    unless auth = find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
      if auth_hash["info"]["email"]
        user = User.find_by(email: auth_hash["info"]["email"])
      end
      unless user
        user = User.create :name => auth_hash["info"]["name"] || auth_hash["info"]["email"],
                           :email => auth_hash["info"]["email"]
      end
      auth = create :user => user,
                    :provider => auth_hash["provider"],
                    :uid => auth_hash["uid"]
    end

    return auth
  end
end
