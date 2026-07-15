class Payment < ActiveRecord::Base
  belongs_to :game

  validates :tier, presence: true
  validates :status, presence: true
  validates :amount_cents, presence: true
end
