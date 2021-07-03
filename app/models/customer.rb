class Customer < ApplicationRecord
  #after_initialize :set_default_values

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cart_items
  has_many :addresses
  has_many :orders

  validates :last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number, presence: true

  attribute :is_active, :boolean, default: true

  #private
  #def set_default_values
    #self.is_active ||= true
  #end

end
