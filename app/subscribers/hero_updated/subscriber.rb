# frozen_string_literal: true

class HeroUpdated::Subscriber
  extend Dry::Initializer

  param :event, reader: :private

  def self.call(event) = new(event).call

  def call
    hero = event[:hero]
    RES.pub HeroUpdated, "Hero##{hero.id}", hero.attributes
  end
end
