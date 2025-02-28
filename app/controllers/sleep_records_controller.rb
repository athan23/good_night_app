class SleepRecordsController < ApplicationController
  before_action :set_user

  def index
    
  end

  def clock_in

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