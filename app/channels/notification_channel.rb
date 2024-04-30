# frozen_string_literal: true

class NotificationChannel < ApplicationCable::Channel
  def subscribed
    reject if token.nil?
    stream_from(token)
  end
end
