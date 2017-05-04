class InventorySerializer < ActiveModel::Serializer
  attributes :water, :food, :medication, :ammo
end

