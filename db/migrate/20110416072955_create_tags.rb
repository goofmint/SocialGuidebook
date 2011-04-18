class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
      t.integer :page_id
      t.timestamps
    end
    remove_column :pages, :categories
  end

  def self.down
    drop_table :tags
    add_column :pages, :string
  end
end
