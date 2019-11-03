# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:user_id])
  end

  def toggle_enabled
    user = User.find(params[:user_id])
    is_enabled = user.enabled?
    user.update_attributes(enabled?: !is_enabled)
    if !is_enabled
      flash[:notice] = "#{user.name} has been enabled!"
    else
      flash[:notice] = "#{user.name} has been disabled!"
    end
    redirect_to admin_users_path
  end

  def edit_profile
    @user = User.find(params[:user_id])
  end

  def update_profile
    @user = User.find(params[:user_id])
    if @user.update(user_profile_params)
      flash[:success] = "#{@user.name}'s profile data has been updated!"
      redirect_to "/admin/users/#{@user.id}"
    else
      flash.now[:error] = @user.errors.full_messages.uniq.to_sentence
      render :edit_profile
    end
  end

  private
    def user_profile_params
      params.permit(:name, :address, :city, :state, :zip, :email)
    end
end
