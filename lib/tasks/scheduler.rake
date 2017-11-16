desc "This task is called by the Heroku scheduler add-on"
task :update_credit_cards_payment_due_date => :environment do
    puts "Updating credit cards payment due dates..."
    CreditCard.where(payment_due_date: Date.today).update_all(payment_due_date: (Date.today + 1.month))
    puts "done."
end

