class AddUrlToCards < ActiveRecord::Migration
  def self.up
    add_column :cards, :url, :text
  end

  def self.down
    remove_column :cards, :url
  end
end
