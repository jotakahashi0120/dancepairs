class MessagesController < ApplicationController
  
  before_action :authenticate_user!, :only => [:create]
  
  # メッセージをcreate
  def create
    # form_forで送られてきたcontentを含む全てのメッセージの情報の:messageと:room_idのキーがちゃんと入っているか
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      # trueなら、trueだったら、メッセージを保存するためにMessage.createとし、
      # Messagesテーブルにuser_id、:content、room_idのパラメーターとして送られてきた値を許可
      # メッセージを送ったのは現在ログインしているユーザーなので、そのuser_idの情報をmerge
      @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id))
      redirect_to "/rooms/#{@message.room_id}"
    else
      redirect_back(fallback_location: root_path)
    end
  end
  
end
