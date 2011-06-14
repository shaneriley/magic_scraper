class CreateCards < ActiveRecord::Migration
  def self.up
    create_table :cards do |t|
      t.text :name
      t.text :color
      t.text :series
      t.text :casting_cost
      t.integer :converted_cost
      t.text :card_type
      t.text :card_text
      t.text :flavor_text
      t.integer :power
      t.integer :toughness

      t.timestamps
    end
  end

  def self.down
    drop_table :cards
  end
end
