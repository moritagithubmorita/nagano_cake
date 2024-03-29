class Order < ApplicationRecord
  enum order_status: {wait: 0, confirmed: 1, making: 2, ready: 3, complete: 4}
  enum payment: {credit: 0, bank: 1}
  belongs_to :customer
  has_many :order_items

  validates :postal_code, :address, :name, :billing_amount, :order_status, :shipping_cost, :payment, :customer_id, presence: true

end
