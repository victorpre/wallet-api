# Wallet API


Demo app and full API reference: https://multicard-wallet.herokuapp.com/

## Clone the project
`git clone https://github.com/victorpre/wallet-api.git && cd wallet-api/`

## Install dependencies
`bundle install`

## Setup your database (This app uses [PostgreSQL](https://www.postgresql.org/?&) )

`rake db:{create,migrate}`

## Run the application
`rails s`

## What can you do?
To see the available routes for api you can visit [this link](https://multicard-wallet.herokuapp.com/) or run `rake routes`

---

## Tests
To run the automated tests using [rspec](https://github.com/rspec/rspec-rails), run:
`rspec spec`
