class Team < ActiveRecord::Base
  belongs_to :game
  has_many :memberships
  has_many :users, :through => :memberships
end
