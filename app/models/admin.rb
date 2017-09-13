class Admin < ApplicationRecord
    validates :username,  presence: true, length: { maximum: 255 }, uniqueness: true
    validates :password,  presence: true, length: { maximum: 255 }, uniqueness: false
end
