class Public::CustomersController < ApplicationController
  def show
  end

  def edit
  end

  def update
    current_customer.update(customer_params)
    redirect_to customers_path
  end

  def confirm
  end

  #退会処理
  def widhdraw
    current_customer.update(is_active: false)
  end

  private

  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :encrypted_password, :postal_code, :address, :telephone_number, :is_active)
  end

end
