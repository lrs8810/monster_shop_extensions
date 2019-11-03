# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.sort_orders
  end

  def update_order_status
    @order = Order.find(params[:order_id])
    @order.update_status(2)
    redirect_to admin_path
  end
end
