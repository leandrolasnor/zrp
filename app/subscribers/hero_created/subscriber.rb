# frozen_string_literal: true

class HeroCreated::Subscriber
  extend Dry::Initializer

  param :event, reader: :private

  def self.call(event) = new(event).call

  def call
    hero = event[:hero]
    RES.pub HeroCreated, "Hero##{hero.id}", hero.attributes
  end
end
