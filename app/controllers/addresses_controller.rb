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
  end

  def update
  end

  def destroy
  end 

  private
    def address_params
      address = params.require(:address).permit(:address, :city, :state, :zip).to_h
      address[:user_id] = current_user.id
      address
    end
end
