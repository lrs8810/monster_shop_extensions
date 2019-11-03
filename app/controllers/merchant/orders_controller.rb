# frozen_string_literal: true

class Merchant::OrdersController < Merchant::BaseController
  def show
    @order = Order.find(params[:order_id])
    @item_orders = @order.find_order(current_user.merchant_id)
  end

  def update_item
    item_order = ItemOrder.find(params[:item_order_id])
    item_order.update_attributes(status: 1)
    item_order.reduce_inventory
    flash[:success] = "The #{item_order.item.name} is now fulfilled."
    item_order.order.update_status(1) if item_order.order.all_items_fulfilled?

    redirect_to merchant_orders_path(params[:order_id])
  end
end
