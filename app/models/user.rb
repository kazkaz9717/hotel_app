class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
end