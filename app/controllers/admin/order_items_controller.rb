class Admin::OrderItemsController < ApplicationController

  def update
    order_item = OrderItem.find(params[:id])
    order_item.update(order_item_edit_params)
    #親である「注文」の全商品の制作ステータスを確認
    #一つでも「製作中」であれば親(注文)の注文ステータスを「製作中」に変更
    OrdersController.update_order_status(Order.find(order_item.order_id))
  end
  
  def self.update_making_status(order_item, making_status)
    order_item.making_status = making_status
    order_item.save
  end
  
  private
  
  def order_item_edit_params
    params.require(:order_item).permit(:making_status)
  end

end
