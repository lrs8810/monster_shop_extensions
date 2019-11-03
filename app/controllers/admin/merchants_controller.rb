
# frozen_string_literal: true

class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def toggle_enabled
    merchant = Merchant.find(params[:merchant_id])
    is_enabled = merchant.enabled?
    merchant.update_attributes(enabled?: !is_enabled)
    merchant.items.update(active?: !is_enabled)
    if !is_enabled
      flash[:success] = "#{merchant.name} has been enabled!"
    else
      flash[:success] = "#{merchant.name} has been disabled!"
    end
    redirect_to merchants_path
  end
end
