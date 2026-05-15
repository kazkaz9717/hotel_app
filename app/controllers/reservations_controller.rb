class ReservationsController < ApplicationController
  before_action :require_login

  def index
    @reservations = current_user.reservations.includes(:room)
  end

  def new
    @room = Room.find(params[:room_id])
    @reservation = Reservation.new
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