class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :daily_record

  validates :comment, presence: true
end
