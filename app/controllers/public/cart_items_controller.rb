class Public::CartItemsController < ApplicationController
  def index
    @cart_items = current_customer.cart_items.all
  end

  def update
    cart_item = CartItem.find(params[:id])
    cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def destroy
    CartItem.find(params[:id]).destroy
    redirect_to cart_items_path
  end

  def remove_all
    #ログインユーザーの全カートアイテムを削除。
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path
  end

  def create
    cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
    #カートに初めて登録された場合
    if cart_item == nil
      CartItem.create(cart_item_params)
    #すでにカートに入っていた場合
    else
      cart_item.update(cart_item_params)
    end

    redirect_to cart_items_path
  end

  def self.to_order_item(order_id, current_customer)
    current_customer.cart_items.all.each do |cart_item|
      order_item = OrderItem.new(order_id: order_id, item_id: cart_item.item_id, amount: cart_item.amount, order_price: Item.find(cart_item.item_id).price, making_status: :impossible)
      order_item.save
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :customer_id, :amount)
  end
end
