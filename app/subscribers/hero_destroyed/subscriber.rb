# frozen_string_literal: true

class HeroDestroyed::Subscriber
  extend Dry::Initializer

  param :event, reader: :private

  def self.call(event) = new(event).call

  def call
    hero = event[:hero]
    RES.pub HeroDestroyed, "Hero##{hero.id}", hero.attributes
  end
end
