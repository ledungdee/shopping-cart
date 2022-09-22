class Shop < ApplicationRecord
  has_many :products 

  validates :user_id, presence: true
  validates :name,  presence: true, length: { maximum: 50 }, uniqueness: true
  
end