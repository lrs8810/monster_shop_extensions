# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
    1.times { @user.addresses.build }
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.name}! You are now logged in and registered."
      redirect_to profile_path
    else
      flash.now[:error] = @user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def edit_profile; end

  def edit_password; end

  def update_profile
    if current_user.update(update_profile_params)
      flash[:success] = 'Your profile data has been updated!'
      redirect_to profile_path
    else
      flash.now[:error] = current_user.errors.full_messages.uniq.to_sentence
      render :edit_profile
    end
  end

  def update_password
    if current_user.update(update_password_params)
      flash[:success] = 'Your password has been updated successfully!'
      redirect_to profile_path
    else
      flash.now[:error] = current_user.errors.full_messages.uniq.to_sentence
      render :edit_password
    end
  end

  def show
    render_404 unless current_user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, addresses_attributes: [:address, :city, :state, :zip])
  end

  def update_profile_params
    params.require(:user).permit(:name, :email)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
