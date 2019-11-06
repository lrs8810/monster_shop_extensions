# frozen_string_literal: true

class OrdersController < ApplicationController
  def new
    @addresses = Address.where(user_id: current_user.id).pluck(:nickname, :id)
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = current_user.orders.create(order_params)
    if order.save
      cart.items.each do |item, quantity|
        order.item_orders.create(
          item: item,
          quantity: quantity,
          price: item.price,
          merchant_id: item.merchant_id
        )
      end
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
    else
      flash.now[:error] = 'Please complete address form to create an order.'
      @addresses = Address.where(user_id: current_user.id).pluck(:nickname, :id)
      render :new
    end
  end

  private

  def order_params
    params.permit(:name, :address_id)
  end
end
