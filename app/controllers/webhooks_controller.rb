class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :stripe

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = if endpoint_secret.present?
        Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      else
        JSON.parse(payload)
      end
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: :bad_request and return
    end

    type = event["type"] || event.dig("type")
    data = event["data"] || {}
    object = data["object"] || {}

    case type
    when "checkout.session.completed"
      handle_checkout_completed(object)
    when "customer.subscription.updated", "customer.subscription.created"
      handle_subscription_update(object)
    end

    head :ok
  end

  private

  def handle_checkout_completed(session)
    customer_id = session["customer"]
    user = User.find_by(stripe_customer_id: customer_id)
    user&.update(subscription_status: "active")
  end

  def handle_subscription_update(subscription)
    customer_id = subscription["customer"]
    status = subscription["status"]
    user = User.find_by(stripe_customer_id: customer_id)
    user&.update(subscription_status: status)
  end
end
