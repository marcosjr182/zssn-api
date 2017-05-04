# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

genders = ['MALE', 'FEMALE']
30.times do |i|
  Survivor.create!(
    name: "Survivor #{i}",
    age: 10 + i,
    gender: genders.shuffle.sample,
    lat: 32.438784,
    lng: 98.48394,
    inventory_attributes: { water: 10, food: 5, ammo: 3 }
  )
end
