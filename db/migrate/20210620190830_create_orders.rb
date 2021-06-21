class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :postal_code
      t.string :address
      t.string :name
      t.integer :billing_amount
      t.integer :order_status
      t.integer :shipping_cost
      t.integer :payment
      t.integer :customer_id

      t.timestamps
    end
  end
end
