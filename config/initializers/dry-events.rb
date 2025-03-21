# frozen_string_literal: true

Rails.configuration.to_prepare do
  Dry::Events::Publisher.registry.clear
end
