class Survivor < ApplicationRecord
  has_and_belongs_to_many :survivors,
    :join_table => 'infected_survivors',
    :foreign_key => 'survivor_id',
    :association_foreign_key => 'infected_id'

  validates :name, presence: true

  def items
    { water: self.water, food: self.food, ammo: self.ammo, medication: self.medication }
  end

  def report(survivor)
    return false if survivor.infected?
    if self.survivors.include? survivor or survivor.infection_count.eql? 2
      unless survivor.infected?
        survivor.infected = true
        survivor.save!
      end

      return false
    else
      survivor.increment!(:infection_count)
      self.survivors.append(survivor)
      return true
    end
  end

  def location
    { lat: self.lat, lng: self.lng }
  end
end
