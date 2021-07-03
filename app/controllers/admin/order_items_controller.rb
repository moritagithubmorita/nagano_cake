class Admin::OrderItemsController < ApplicationController
  skip_before_action :authenticate_customer!
  before_action :authenticate_admin!

  def update
    order_item = OrderItem.find(params[:id])
    order_item.update(making_status: params[:order_item][:making_status].to_i)
    #親である「注文」の全商品の制作ステータスを確認
    #一つでも「製作中」であれば親(注文)の注文ステータスを「製作中」に変更
    Admin::OrdersController.update_order_status(Order.find(order_item.order_id))
    redirect_to admin_order_path(order_item.order_id)
  end

  def self.update_making_status(order_item, making_status)
    order_item.update(making_status: making_status)
  end

end
