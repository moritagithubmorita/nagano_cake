class Public::AddressesController < ApplicationController
  before_action :check_login_customer, only: :edit

  def check_login_customer
    if current_customer.id != Address.find(params[:id]).customer_id
      redirect_to addresses_path
    end
  end

  def index
    @address = Address.new
    @addresses = current_customer.addresses.all
  end

  def edit
    @edited_address = Address.new
    @address = Address.find(params[:id])
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      redirect_to addresses_path
    else
      @addresses = current_customer.addresses.all
      render :index
    end
  end

  def update
    @edited_address = Address.find(params[:id])
    if @edited_address.update(address_params)
      redirect_to addresses_path
    else
      @address = Address.find(params[:id])
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:customer_id, :name, :postal_code, :address)
  end
end
