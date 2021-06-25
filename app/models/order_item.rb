class OrderItem < ApplicationRecord
  enum making_status: {impossible: 0, wait: 1, making: 2, complete: 3}
  belongs_to :order
  belongs_to :item
end
