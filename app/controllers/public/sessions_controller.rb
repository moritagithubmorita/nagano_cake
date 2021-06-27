# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  #退会顧客がログインできないようにする
  before_action :loginable_check, only: [:create]

  #退会済み顧客
  def loginable_check
    #入力メアドとパスワードに合致するCustomerを検索
    customer = Customer.find_by(email: params[:email], password: params[:password])
    #退会済み顧客だった場合
    if (customer && !customer.is_active)
      redirect_to new_customer_registration_path
    end
  end
  
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
