class RoomsController < ApplicationController
  before_action :require_login, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    @rooms = current_user.rooms
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      redirect_to @room, notice: "施設を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    unless request.referrer&.include?('/reservations') || request.referrer&.include?('/edit')
      session[:return_to] = request.referrer
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to @room, notice: "施設情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy
    redirect_to rooms_path, notice: "施設を削除しました"
  end

  def search
    @rooms = Room.all
    @rooms = @rooms.where("address LIKE ?", "%#{params[:area]}%") if params[:area].present?
    @rooms = @rooms.where("name LIKE ? OR description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%") if params[:keyword].present?
    @count = @rooms.count
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :room_image)
  end

  def check_owner
    unless @room.user == current_user
      redirect_to rooms_path, alert: "権限がありません"
    end
  end
end