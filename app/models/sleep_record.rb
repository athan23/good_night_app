class SleepRecord < ApplicationRecord
  belongs_to :user

  before_save :calculate_duration

  # Add a callback in SleepRecord to clear cache when a record is created or updated
  # This ensures cached data stays fresh when users log sleep or update records
  after_commit :clear_cache

  private

  def calculate_duration
    self.duration = clock_out && clock_in ? (clock_out - clock_in).to_i : 0
  end

  def clear_cache
    Rails.cache.delete_matched("user_#{user_id}_sleep_records_page_*")
  end
end
