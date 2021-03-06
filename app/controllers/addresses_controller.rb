class AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def create
    @address = Address.create(address_params)
    if @address.save
      flash[:success] = 'Your address has been added!'
      redirect_to profile_path
    else
      flash.now[:error] = @address.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def edit
    @address = Address.find(params[:address_id])
  end

  def update
    @address = Address.find(params[:address_id])
    if @address.update(address_params)
      flash[:success] = 'Your address has been updated!'
      redirect_to profile_path
    else
      flash.now[:error] = @address.errors.full_messages.uniq.to_sentence
      render :edit
    end
  end

  def disable
    address = Address.find(params[:address_id])
    if address.orders.empty? || address.all_orders_cancelled?
      address.toggle!(:enabled?)
    else
      flash[:error] = "This address is currently in use for one or more of your orders. Please edit the shipping address on any Pending or Packaged orders and then try again."
    end
    redirect_to profile_path
  end

  private
    def address_params
      address = params.require(:address).permit(:address, :city, :state, :zip).to_h
      address[:user_id] = current_user.id
      address
    end
end
