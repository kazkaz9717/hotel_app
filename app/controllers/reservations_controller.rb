class ReservationsController < ApplicationController
  before_action :require_login

  def index
    @current_reservations = current_user.reservations.includes(:room).where("check_out >= ?", Date.today).order(check_in: :asc)
    @past_reservations = current_user.reservations.includes(:room).where("check_out < ?", Date.today).order(check_in: :desc)
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def edit
    @reservation = current_user.reservations.find(params[:id])
    @room = @reservation.room
  end

  def update
    @reservation = current_user.reservations.find(params[:id])
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
      Rails.logger.debug @reservation.errors.full_messages
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
    @reservation = current_user.reservations.find(params[:id])
    @reservation.destroy
    redirect_to reservations_path, notice: "予約を削除しました"
  end

  private

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :guests)
  end
end