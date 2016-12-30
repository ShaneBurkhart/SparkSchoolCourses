#require 'sinatra'
require 'stripe'

Stripe.api_key = ENV['STRIPE_SECRET']

post '/payments' do
    token = params[:stripeToken]

    begin
        charge = Stripe::Charge.create(
            :amount => 29900,
            :currency => "usd",
            :source => token,
            :description => "Presell purchase of the 6 week SaaS web app course."
        )
        redirect "https://trysparkschool.com/saas-success"
    rescue Stripe::CardError => e
        redirect "https://trysparkschool.com/saas-declined"
    end
end
