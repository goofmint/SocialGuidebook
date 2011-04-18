class PagesAddMeta < ActiveRecord::Migration
  def self.up
    add_column :pages, :meta, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :meta
  end
end
