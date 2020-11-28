class DailyRecord < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :theme, :introduction, :genre, presence: true
  attachment :daily_image

  enum genre: {
    食事: 0,
    運動: 1,
    その他: 2
  }
end
