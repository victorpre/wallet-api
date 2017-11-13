FactoryBot.define do
  factory :wallet do
    user

    trait :with_credit_cards do
      credit_cards { create_list(:credit_card, 5) }
    end
  end
end
