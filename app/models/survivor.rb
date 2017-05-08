class Survivor < ApplicationRecord
  has_and_belongs_to_many :survivors,
    :join_table => 'infected_survivors',
    :foreign_key => 'survivor_id',
    :association_foreign_key => 'infected_id'

  has_one :inventory
  accepts_nested_attributes_for :inventory
  before_create :build_default_inventory

  validates :name, presence: true

  scope :healthy,  -> { where(infected: false) }
  scope :infected, -> { where(infected: true) }

  def items
    InventorySerializer.new(self.inventory)
  end

  def location
    { lat: self.lat, lng: self.lng }
  end

  private
  def build_default_inventory
    build_inventory unless self.inventory
    true
  end
end
