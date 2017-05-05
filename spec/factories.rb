FactoryGirl.define do

  factory :inventory do |i|
    water 1
    food  2
    medication 3
    ammo 4
  end

  factory :survivor do |s|
    s.sequence(:name) {|n| "Survivor #{n}"}

    s.association :inventory
  end

end
