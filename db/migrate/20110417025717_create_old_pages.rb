class CreateOldPages < ActiveRecord::Migration
  def self.up
    create_table :old_pages do |t|
      t.string :title, :null => false
      t.text   :body
      t.decimal :latitude, :precision => 17, :scale => 14, :default => 0.0, :null => false
      t.decimal :longitude, :precision => 17, :scale => 14, :default => 0.0, :null => false
      t.integer :page_id
      t.string :address, :icon_id
      t.boolean :meta, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :old_pages
  end
end
