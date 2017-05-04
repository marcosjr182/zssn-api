class RemoveColumnsFromSurvivors < ActiveRecord::Migration[5.0]
  def change
    remove_column :survivors, :water, :integer
    remove_column :survivors, :food, :integer
    remove_column :survivors, :medication, :integer
    remove_column :survivors, :ammo, :integer
  end
end
