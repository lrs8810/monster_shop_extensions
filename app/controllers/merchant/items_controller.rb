# frozen_string_literal: true

class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = current_user.merchant.items
  end

  def new; end

  def create
    merchant = current_user.merchant
    item = merchant.items.create(item_params)
    if item.save
      flash[:success] = 'Item was successfully created!'
      redirect_to merchant_user_items_path
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @item = Item.find(params[:item_id])
  end

  def update
    @item = Item.find(params[:item_id])
    @item.update(item_params)
    if @item.save
      flash[:success] = 'Item was successfully updated!'
      redirect_to merchant_user_items_path
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def activate_deactivate
    if params[:activate_deactivate] == 'deactivate'
      item = Item.find(params[:item_id])
      item.toggle!(:active?)
      flash[:notice] = "#{item.name} is now deactivated and is no longer for sale."
    elsif params[:activate_deactivate] == 'activate'
      item = Item.find(params[:item_id])
      item.toggle!(:active?)
      flash[:notice] = "#{item.name} is now activated and available for sale."
    end
    redirect_to merchant_user_items_path
  end

  def disable_item
    item = Item.find(params[:item_id])
    item.toggle!(:enabled?)
    flash[:notice] = "#{item.name} is now removed from #{item.merchant.name}'s online inventory."
    redirect_to merchant_user_items_path
  end

  private

  def item_params
    params[:image] = 'https://bit.ly/34a6p1g' if params[:image] == ''
    params.permit(:name, :description, :price, :inventory, :image)
  end
end
