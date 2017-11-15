FactoryBot.define do
  factory :credit_card do
    wallet
    limit { Faker::Number.number(4) }
    number '4043585409298248'
    card_holder { Faker::Name.name }
    exp_month { 6 }
    exp_year { Date.today.year + 4 }
    payment_due_date { Date.today + 7.days  }
    cvv 123

    trait :valid_balance do
      limit 1
      balance 0
    end

    trait :invalid_balance do
      limit 0
      balance 1
    end

    trait :invalid_payment_due_date do
      payment_due_date { Date.today - 7.days  }
    end
  end
end
