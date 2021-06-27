class Public::CustomersController < ApplicationController
  def show
  end

  def edit
  end

  def update
    @edited_customer = current_customer
    if @edited_customer.update(customer_params)
      redirect_to customers_path
    else
      render edit
    end
  end

  def confirm
  end

  #退会処理
  def widhdraw
    current_customer.update(is_active: false)
    
    #ログアウト
    redirect_to destroy_customer_session_path
  end

  private

  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :encrypted_password, :postal_code, :address, :telephone_number, :is_active)
  end

end
