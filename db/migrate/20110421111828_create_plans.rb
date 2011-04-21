class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer :user_id
      t.string  :title
      t.text    :description
      t.timestamp :start_at
      t.timestamp :end_at
      t.integer   :dates
      t.boolean   :public, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
