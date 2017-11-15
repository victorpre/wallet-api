FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    password_confirmation { password }


    trait :with_credit_cards do
      after(:create) do |user|
        wallet = user.wallet
        wallet.credit_cards << create(:credit_card)
      end
    end

    trait :in_debt do
      after(:create) do |user|
        wallet = user.wallet
        4.times do
          wallet.credit_cards << create(:credit_card, :with_high_balance)
        end
      end
    end
  end
end
