class Item < ApplicationRecord
  attachment :image
  belongs_to :genre
  has_many :cart_items
  has_many :order
  
  validates :name, :introduction, :price, :image, presence: true
end
