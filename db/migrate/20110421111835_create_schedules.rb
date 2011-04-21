class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.integer :user_id
      t.integer :plan_id
      t.timestamp :date
      t.integer   :day
      t.text      :memo
      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
