class UsersController < ApplicationController
  
  before_action :authenticate_user!, except: [:index]
  
  def index
    @users = User.all.order(updated_at: :desc)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to users_path, alert: '不正なアクセスです！'
    end
  end
  
  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: '更新しました！'
    else
      render :edit
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:username, :email, :password, :profile_image, :gender, :prefecture, :profile)
    end
end
