FactoryGirl.define do
  factory :inventory do
    water 1
    food 1
    medication 1
    ammo 1
    survivor nil
  end

  factory :survivor do |s|
    s.sequence(:name) {|n| "Survivor #{n}"}

    trait :with_items do
      after(:create) do |object|
        object.inventory.update!(water: 1, food: 2, medication: 3, ammo: 4)
      end
    end
  end

end
