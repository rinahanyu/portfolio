class Hospital < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, :postal_code, :address, :telphone_number, :email, presence: true
  validates :telphone_number, :postal_code, numericality: {only_integer: true}
end
