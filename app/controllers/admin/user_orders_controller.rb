class Admin::UserOrdersController < Admin::BaseController

  def show
    @order = Order.find(params[:order_id])
  end

  def update
    order = Order.where(id: params[:order_id], user_id: params[:user_id]).first
    order.update(status: 'Cancelled')
    order.item_orders.each do |item_order|
      item_order.return_inventory if item_order.status == 'Fulfilled'
      item_order.update_attributes(status: 'Unfulfilled')
    end
    flash[:notice] = 'Order has been cancelled!'
    redirect_to admin_users_path(params[:user_id])
  end

end
