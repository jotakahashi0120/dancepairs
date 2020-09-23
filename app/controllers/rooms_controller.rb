class RoomsController < ApplicationController
  
  before_action :authenticate_user!
  
  # 新しくRoomとEntryを作成
  def create
    # Room_idを作成
    @room = Room.create
    # current_userをEntryに登録
    # current_userのEntry情報として、current_userのidと新しくできたroomのidを保存
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id)
    # showのユーザーをEntryに登録
    # user#showで代入した@userの情報をidへ代入。そこに新しくできた:room_idをmergeして登録
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id))
    # createと同時にチャットルームが開くようにredirect
    redirect_to "/rooms/#{@room.id}"
  end
  
  # 該当するチャットルームを表示
  def show
    @room = Room.find(params[:id])
    # Entriesテーブルに、current_userのidとそれにひもづいたチャットルームのidをwhereメソッドで探し、
    # そのレコードがあるか確認
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      # レコードがあるなら、Messageテーブルにそのチャットルームのidと紐づいたメッセージを表示させるため、
      # @messagesにアソシエーションを利用した@room.messagesという記述を代入
      @messages = @room.messages
      # 新しくメッセージを作成する場合は、メッセージのインスタンスを生成するために、
      # Message.newをし、@messageに代入
      @message = Message.new
      # rooms/show.html.erbでユーザーの名前などの情報を表示させるために、
      # @room.entriesを@entriesというインスタンス変数に入れ、Entriesテーブルのuser_idの情報を取得
      @entries = @room.entries
    else
      # レコードがなかったら前のページに戻るためにredirect_back
      redirect_back(fallback_location: root_path)
    end
  end
  
end
