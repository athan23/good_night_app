class SleepRecordsController < ApplicationController
  before_action :set_user

  def index
    records = @user.sleep_records.order(:created_at)
    render json: records
  end

  def clock_in
    # User can only clock in if there is no active sleep record
    if @user.sleep_records.where(clock_out: nil).exists?
      return render json: { error: "User already has an active sleep record" }, status: :bad_request
    end

    record = @user.sleep_records.create!(clock_in: Time.current)
    render json: record, status: :created
  end
  
  def clock_out
    # User can only clock out if there is an active sleep record
    record = @user.sleep_records.where(clock_out: nil).first
    return render json: { error: "No active sleep record found" }, status: :bad_request unless record

    record.update(clock_out: Time.current)
    render json: record
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end
end