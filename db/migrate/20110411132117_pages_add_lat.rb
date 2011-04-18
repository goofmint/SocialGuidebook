class PagesAddLat < ActiveRecord::Migration
  def self.up
    add_column :pages, :latitude, :decimal, :precision => 17, :scale => 14, :default => 0.0, :null => false
    add_column :pages, :longitude, :decimal, :precision => 17, :scale => 14, :default => 0.0, :null => false
    add_column :pages, :page_id, :integer
    add_column :pages, :address, :string
  end

  def self.down
    remove_column :pages, :latitude
    remove_column :pages, :longitude
    remove_column :pages, :page_id
    remove_column :pages, :address
  end
end
