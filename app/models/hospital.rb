class Hospital < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :medical_relationships
  has_many :patients, through: :medical_relationships, source: :user
  has_many :medical_records, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, :postal_code, :address, :telphone_number, :email, presence: true
  validates :telphone_number, :postal_code, numericality: {only_integer: true}

  # かかりつけ医の登録をしている患者かどうか
  def patients?(user)
    self.medical_relationships.find_by(user_id: user.id).present?
  end

  def self.search(content)
    Hospital.where("name LIKE? OR telphone_number LIKE? OR postal_code LIKE? OR address LIKE?", "%#{content}%", "#{content}", "#{content}", "%#{content}%")
  end
end
