FactoryGirl.define do

  factory :inventory do |i|
    i.water 1
    i.food  2
    i.medication 3
    i.ammo 4
  end

  factory :survivor do |s|
    s.sequence(:name) {|n| "Survivor #{n}"}

    s.association :inventory
  end

end
