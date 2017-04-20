class SurvivorSerializer < ActiveModel::Serializer
  attributes :id, :name, :gender, :age, :items, :location
end

