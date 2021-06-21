class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.page(params[:page]).reverse_order
  end

  def show
  end

  def edit
  end
end
