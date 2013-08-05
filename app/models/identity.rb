class Identity < OmniAuth::Identity::Models::ActiveRecord
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A.+@.+\..+\z/
end