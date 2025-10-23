class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    price_id = ENV["STRIPE_PRICE_ID"]
    unless price_id.present?
      redirect_to root_path, alert: "missing stripe price id"
      return
    end

    begin
      ensure_stripe_customer!

      session = Stripe::Checkout::Session.create(
        mode: "subscription",
        customer: current_user.stripe_customer_id,
        line_items: [{ price: price_id, quantity: 1 }],
        success_url: root_url + "?checkout=success",
        cancel_url: root_url + "?checkout=cancel"
      )

      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      redirect_to root_path, alert: "stripe error: #{e.message}"
    rescue => _e
      redirect_to root_path, alert: "unexpected error starting checkout"
    end
  end

  def destroy
    # Implement cancellation or portal redirection later
    redirect_to root_path, notice: "subscription management coming soon"
  end

  private

  def ensure_stripe_customer!
    return if current_user.stripe_customer_id.present?

    customer = Stripe::Customer.create(email: current_user.email)
    current_user.update!(stripe_customer_id: customer.id)
  rescue Stripe::StripeError
    raise
  rescue => _e
    raise
  end
end
