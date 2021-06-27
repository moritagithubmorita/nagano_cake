class Public::OrdersController < ApplicationController
  SHIPPING_COST=800 #送料
  @@draft_order=nil #注文情報保留用、使い回しインスタンス
  
  def new
    @order = Order.new
    
    #「アドレス 名前」と配送先idをペアにしたハッシュを作成
    @address_name_hash = {}
    @addresses = current_customer.addresses.all
    @addresses.each do |address|
      result = address.address + " " + address.name
      @address_name_hash[result]=address_id #キー:アドレスと名前, 値:address_id
    end
    
  end

  def confirm
    @cart_items = current_customer.cart_items.all
    billing_amount=0
    
    #請求金額
    @cart_items.each do |cart_item|
      item = Item.find(cart_item.item_id)
      billing_amount += item.price*1.08
    end
    billing_amount+=SHIPPING_COST
    
    case params[:selected_address]
      #ご自身の住所
      when 0
        @@draft_order = @order = Order.new(postal_code: current_customer.postal_code, address: current_customer.address, name: current_customer.last_name+current_customer.first_name, billing_amount: billing_amount, order_status: 0, shipping_cost: SHIPPING_COST, payment: params[:payment], customer_id: current_customer.id)
      #登録済の住所
      when 1
        address_name_hash = params[:address_name_hash]  #実は、配送先idが取れます
        address = Address.find(address_name_hash)
        @@draft_order=@order = Order.new(postal_code: address.postal_code, address: address.address, name: address.last_name+address.first_name, billing_amount: billing_amount, order_status: 0, shipping_cost: SHIPPING_COST, payment: params[:payment], customer_id: current_customer.id)
      #新規住所
      when 2
        @@draft_order=@order = Order.new(postal_code: params[:postal_code], address: params[:address], name: params[:name], billing_amount: billing_amount, order_status: 0, shipping_cost: SHIPPING_COST, payment: params[:payment], customer_id: current_customer.id)
    end
    
    @@draft_order.customer_id = current_customer.id
  end

  def thanks
  end

  def create
    if @@draft_order.save
      @@draft_order = nil
      #カートから商品を全削除
      current_customer.cart_items.all.destroy_all
      redirect_to orders_thanks_path
    else
      @order = Order.new
      #「アドレス 名前」と配送先idをペアにしたハッシュを作成
      @address_name_hash = {}
      @addresses = current_customer.addresses.all
      @addresses.each do |address|
        result = address.address + " " + address.name
        @address_name_hash[result]=address_id #キー:アドレスと名前, 値:address_id
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
    params.require(:order).permit(:payment)
  end
end
