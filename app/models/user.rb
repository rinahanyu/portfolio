class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :daily_records, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telphone_number, :email, presence: true
  validates :telphone_number, :postal_code, numericality: {only_integer: true}
  attachment :profile_image
end
