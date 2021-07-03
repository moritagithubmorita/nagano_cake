class Admin::HomesController < ApplicationController
  #before_action :authenticate_admin!
  skip_before_action :authenticate_customer!
  before_action :authenticate_admin!

  def top

    if params[:customer_id]
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders.page(params[:page]).per(10)
      @from_customer_show = true
    else
      @customer = Customer.new
      @orders = Order.page(params[:page]).per(10)
      @from_customer_show = false
    end
  end
end
