class Chat < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :hospital, optional: true
  belongs_to :room

  validates :message, presence: true
end
