class SleepRecord < ApplicationRecord
  belongs_to :user

  after_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete_matched("user_#{user_id}_sleep_records_page_*")
  end
end
