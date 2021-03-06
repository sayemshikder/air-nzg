class Api::UsersController < ApplicationController
  
  def index
    @users = User.all
    render :index
  end
  
  def show
    @user = User.find(params[:id])
    
    if params[:id] == current_user.id.to_s
      render :show_full
    else
      render :show_limited
    end
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      sign_in @user
      render json: @user
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def update
    @user = User.find(params[:id])
    
    if current_user.update(user_params)
      render json: @user
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity
    end
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :fname, :lname, :avatar, :locale, :description)
  end
  
end