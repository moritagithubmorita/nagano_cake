class Admin::OrdersController < ApplicationController
  def show
    @order = Order.find(params[:id])
  end
  
  def update
    order = Order.find(params[:id])
    order.update(order_update_params)
    #入金確認になったら全ての商品を「製作待ち」に変更
    if order.confirmed?
      order.order_items.all.each do |order_item|
        OrderItems.update_making_status(order_item, :wait)
      end
  end
  
  def self.update_order_status(order)
    complete = true #全ての商品のステータスが「製作完了」かどうか
    
    order.order_items.all.each do |order_item|
      #1個でも製作中なら製作ステータスを「製作中」にする
      if order_item.making?
        order.making!
        order.save
        return  #抜ける
      #1つでも製作完了してなければcomplete=false
      elsif !order_item.complete?
        complete=false
      end
    end
    
    #製作完了に変更
    if complete
      order.complete!
      order.save
    end
  end
  
  private
  
  def order_update_params
    params.require(:order).permit(:order_status)
  end
end
