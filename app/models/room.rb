class Room < ApplicationRecord
  belongs_to :user
  belongs_to :hospital
  has_many :chats, dependent: :destroy
end
