class SleepRecordsController < ApplicationController
  before_action :set_user

  def index
    
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
    
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end
end