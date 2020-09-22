class UsersController < ApplicationController
  def index
    @users = User.all.order(updated_at: :desc)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end
end
