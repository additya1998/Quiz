class User < ApplicationRecord
	before_save { self.email = email.downcase }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :username,  presence: true, length: { maximum: 255 }, uniqueness: true
	validates :password,  presence: true, length: { maximum: 255 }, uniqueness: false
	validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
    has_secure_password

	has_many :games
end
