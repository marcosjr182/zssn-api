class Survivor < ApplicationRecord
  validates :name, presence: true

  def items
    { water: self.water, food: self.food, ammo: self.ammo, medication: self.medication }
  end

  def location
    { lat: self.lat, lng: self.lng }
  end
end
