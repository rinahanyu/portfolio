class Favorite < ApplicationRecord
  belongs_to :users, optional: true
  belongs_to :daily_record
end
