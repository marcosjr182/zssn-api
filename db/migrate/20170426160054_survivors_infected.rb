class SurvivorsInfected < ActiveRecord::Migration[5.0]
  def change
    create_table 'infected_survivors', force: true, id: false do |t|
      t.integer 'infected_id', null: false
      t.integer 'survivor_id', null: false
    end
  end
end
