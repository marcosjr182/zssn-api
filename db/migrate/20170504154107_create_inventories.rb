class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.integer :water,       :default => 0
      t.integer :food,        :default => 0
      t.integer :medication,  :default => 0
      t.integer :ammo,        :default => 0
      t.references :survivor, foreign_key: true

      t.timestamps
    end
  end
end
