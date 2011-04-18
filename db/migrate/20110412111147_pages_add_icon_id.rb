class PagesAddIconId < ActiveRecord::Migration
  def self.up
    add_column :pages, :icon_id, :string
  end

  def self.down
    remove_column :pages, :icon_id, :string
  end
end
