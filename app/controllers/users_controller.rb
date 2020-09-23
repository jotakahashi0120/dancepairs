class UsersController < ApplicationController
  
  before_action :authenticate_user!, except: [:index]
  
  def index
    @users = User.all.order(updated_at: :desc)
    # パラメータとして性別を受け取っている場合は絞って検索する
    if params[:gender].present?
      @users = @users.get_by_gender params[:gender]
    end
    # パラメータとして住所を受け取っている場合は絞って検索する
    if params[:prefecture].present?
      @users = @users.get_by_prefecture params[:prefecture]
    end
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
    if @user.update_attributes(user_params)
      sign_in(@user, bypass: true)
      redirect_to user_path(@user), notice: '更新しました！'
    else
      render :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end
  
  private
  
    def user_params
      params.require(:user).permit(:username, :email, :password, :profile_image, :gender, :prefecture, :profile)
    end
    
end
