class Favorite < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :daily_record
end
