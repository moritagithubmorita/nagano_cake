class Public::OrdersController < ApplicationController
  #カートに商品がひとつもない時、注文情報を入力できないようにする
  before_action :cart_is_empty, if: :is_cart_empty, only: :new
  before_action :check_login_customer, only: :show

  SHIPPING_COST=800 #送料

  def is_cart_empty
    if current_customer.cart_items.count == 0
      return true
    else
      return false
    end
  end

  def cart_is_empty
    flash[:alert] = 'カートが空です。'
    redirect_to cart_items_path
  end
  
  def check_login_customer
    if current_customer.id != Order.find(params[:id]).customer_id
      redirect_to orders_path
    end
  end

  def new
    @order = Order.new

    #「アドレス 名前」と配送先idをペアにしたハッシュを作成
    @address_name_hash = {}
    @addresses = current_customer.addresses.all
    @addresses.each do |address|
      result = address.address + " " + address.name
      @address_name_hash[result]=address.id #キー:アドレスと名前, 値:address.id
    end

  end

  def confirm
    #処理の流れ
    #1.表示用インスタンス(@order)作成
    #2.バリデーションチェックをしてダメなら再入力、okならconfirmに遷移

    @cart_items = current_customer.cart_items.all
    billing_amount=0

    #請求金額
    @cart_items.each do |cart_item|
      item = Item.find(cart_item.item_id)
      billing_amount += (((item.price)*1.08).floor)*(cart_item.amount)
    end
    billing_amount+=SHIPPING_COST

    case params[:order][:selected_address]
      #ご自身の住所
      when '0'
        @order = Order.new(postal_code: current_customer.postal_code, address: current_customer.address, name: current_customer.last_name+current_customer.first_name, billing_amount: billing_amount, order_status: 0, shipping_cost: SHIPPING_COST, payment: params[:order][:payment].to_i, customer_id: current_customer.id)
      #登録済の住所
      when '1'
        address_name_hash = params[:order][:address_name_hash]  #実は、配送先idが取れます
        address = Address.find(address_name_hash)
        @order = Order.new(postal_code: address.postal_code, address: address.address, name: address.name, billing_amount: billing_amount, order_status: 0, shipping_cost: SHIPPING_COST, payment: params[:order][:payment].to_i, customer_id: current_customer.id)
      #新規住所
      when '2'
        @order = Order.new(postal_code: params[:order][:postal_code], address: params[:order][:address], name: params[:order][:name], billing_amount: billing_amount, order_status: 0, shipping_cost: SHIPPING_COST, payment: params[:order][:payment].to_i, customer_id: current_customer.id)
      else
      p "fault"
    end

    @order.customer_id = current_customer.id

    #バリデーションエラーがあった場合
    if @order.invalid?
      @address_name_hash = {}
      @addresses = current_customer.addresses.all
      @addresses.each do |address|
        result = address.address + " " + address.name
        @address_name_hash[result]=address.id #キー:アドレスと名前, 値:address.id
      end
      render :new
    end

  end


  def thanks
  end

  def create
    @order = Order.new(order_params)
    @order.billing_amount = params[:order][:billing_amount].to_i
    @order.order_status = params[:order][:order_status].to_i
    @order.shipping_cost = params[:order][:shipping_cost].to_i
    @order.payment = params[:order][:payment].to_i
    @order.customer_id = params[:order][:customer_id].to_i

    if @order.save
      #カートの中身を注文に紐付ける
      Public::CartItemsController.to_order_item(@order.id, current_customer)
      #カートから商品を全削除
      current_customer.cart_items.all.destroy_all
      redirect_to orders_thanks_path
    else
      #ここに来ることは想定していない
      @address_name_hash = {}
      @addresses = current_customer.addresses.all
      @addresses.each do |address|
        result = address.address + " " + address.name
        @address_name_hash[result]=address.id #キー:アドレスと名前, 値:address_id
      end
      render :new
    end
  end

  def index
    @orders = current_customer.orders.all
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:postal_code, :address, :name)
  end
end
