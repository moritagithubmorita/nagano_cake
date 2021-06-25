class Admin::HomesController < ApplicationController
  def top
    
    if params[:customer_id]
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders.page(params[:page]).per(10).reverse_order
      @from_customer_show = true
    else
      @customer = Customer.new
      @orders = Order.page(params[:page]).per(10).reverse_order
      @from_customer_show = false
    end
  end
end
