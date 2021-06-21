class Order < ApplicationRecord
  enum order_status: {wait: 0, confirmed: 1, making: 2, ready: 3, complete: 4}
  enum payment: {credit: 0, bank: 1}
end
