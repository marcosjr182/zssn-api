class CreateSurvivors < ActiveRecord::Migration[5.0]
  def change
    create_table :survivors do |t|
      t.string :name,         null: false
      t.string :gender
      t.integer :age
      t.float :lat,           null: false
      t.float :lng,           null: false
      t.integer :water,       default: 0
      t.integer :food,        default: 0
      t.integer :medication,  default: 0
      t.integer :ammo,        default: 0
      t.boolean :infected,    default: false

      t.timestamps
    end
  end
end
