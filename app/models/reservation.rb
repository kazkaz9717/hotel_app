class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :check_in, presence: true
  validates :check_out, presence: true
  validates :guests, presence: true, numericality: { greater_than_or_equal_to: 1, message: "は1人以上を入力してください" }

  validate :check_in_must_be_future
  validate :check_out_must_be_after_check_in

  private

  def check_in_must_be_future
    return if check_in.blank?
    errors.add(:check_in, "は本日以降の日付を選択してください") if check_in < Date.today
  end

  def check_out_must_be_after_check_in
    return if check_in.blank? || check_out.blank?
    errors.add(:check_out, "はチェックイン日より後の日付を選択してください") if check_out <= check_in
  end
end