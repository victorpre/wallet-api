FactoryBot.define do
  factory :credit_card do
    wallet
    limit { Faker::Number.number(4) }
    number '4043585409298248'
    card_holder { Faker::Name.name }
    expiration_date { Date.today + 4.years}
    cvv 123

    trait :valid_balance do
      limit 1
      balance 0
    end

    trait :invalid_balance do
      limit 0
      balance 1
    end
  end
end
