class AddImageToCards < ActiveRecord::Migration
  def self.up
    add_column :cards, :image, :text
  end

  def self.down
    remove_column :cards, :image
  end
end
