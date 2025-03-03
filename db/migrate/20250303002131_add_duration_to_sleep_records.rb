class AddDurationToSleepRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :sleep_records, :duration, :integer
  end
end
