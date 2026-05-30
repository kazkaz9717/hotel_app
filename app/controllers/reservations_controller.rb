class ReservationsController < ApplicationController
  before_action :require_login
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]

  def index
    @current_reservations = current_user.reservations.includes(:room).where("check_out >= ?", Date.today).order(check_in: :asc)
    @past_reservations = current_user.reservations.includes(:room).where("check_out < ?", Date.today).order(check_in: :desc)
  end

  def show
  end

  def edit
    @room = @reservation.room
  end

  def update
    @room = @reservation.room
    if @reservation.update(reservation_params)
      redirect_to reservation_path(@reservation), notice: "予約を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
  end

  def confirm
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new(reservation_params)
    @reservation.room_id = @room.id
    @reservation.user_id = current_user.id
    if @reservation.valid?
      nights = (@reservation.check_out - @reservation.check_in).to_i
      @total_price = @room.price * nights * @reservation.guests
      render :confirm
    else
      render :new, status: :unprocessable_entity
    end
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room_id = @room.id
    if @reservation.save
      redirect_to reservations_path, notice: "予約が完了しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @reservation.destroy
    redirect_to reservations_path, notice: "予約を削除しました"
  end

  private

  def set_reservation
    @reservation = current_user.reservations.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :guests)
  end
end