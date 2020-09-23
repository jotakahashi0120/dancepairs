class UsersController < ApplicationController
  
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
  
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
    
    # roomがcreateされた時に、現在ログインしているユーザーと、
    # 「チャットへ」を押されたユーザーの両方をEntriesテーブルに記録する必要がある
    
    # 自分(current_user)が参加しているメッセージルーム情報を取得する
    @currentUserEntry=Entry.where(user_id: current_user.id)
    # 選択したユーザのメッセージルーム情報を取得する
    @userEntry=Entry.where(user_id: @user.id)
    
    # 自分(current_user)と選択したユーザ間に共通のメッセージルームが存在すればフラグを立てる
    
    # 選択したユーザーidと自分(current_user)のidが異なるとき
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          # 2つのブロック引数の中に同じRoom_idがあるかを確認
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      # もし2つのEntryに同じroom_idが見つからない場合新しくRoomとEntryを作る
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
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
