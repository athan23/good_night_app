class SleepRecordsController < ApplicationController
  include Pagy::Backend

  before_action :set_user

  def index
    cache_key = "user_#{params[:user_id]}_sleep_records_page_#{params[:page]}"
    @pagy, @sleep_records = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      pagy(@user.sleep_records.order(:created_at))
    end
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

  def feed
    cache_key = "user_#{params[:user_id]}_sleep_records_feed_page_#{params[:page]}"

    sleep_record_table = SleepRecord.arel_table
    sleep_duration = sleep_record_table[:clock_out] - sleep_record_table[:clock_in]

    @pagy, @sleep_records = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      followee_ids = @user.followees.pluck(:id)

      sorted_sleep_records = SleepRecord
                              .select("*, (clock_out - clock_in) AS sleep_duration")
                              .where(user_id: followee_ids)
                              .where("clock_out IS NOT NULL")
                              .where("clock_out >= ?", 7.days.ago)
                              .order(duration: :desc)

      pagy(sorted_sleep_records)
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end
end