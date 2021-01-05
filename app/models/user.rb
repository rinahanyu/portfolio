class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :daily_records, dependent: :destroy
  has_many :medical_histories, dependent: :destroy
  has_many :health_cares, dependent: :destroy
  has_many :medical_records, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

  has_many :medical_relationships
  has_many :families, through: :medical_relationships, source: :hospital

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :last_name, :first_name, :last_name_kana, :first_name_kana, :address, :email,
            presence: true
  validates :telphone_number, :postal_code, numericality: { only_integer: true }
  attachment :profile_image

  # かかりつけ医の登録がされているかどうか
  def families?(hospital)
    medical_relationships.find_by(hospital_id: hospital.id).present?
  end
end
