# frozen_string_literal: true

class AllocateResource::Steps::Matches
  include Dry::Monads[:result]
  extend  Dry::Initializer

  option :battle, type: Types::Interface(:find), default: -> { AllocateResource::Model::Battle }, reader: :private
  option :heroes,
         type: Types::Interface(:allocatable),
         default: -> { AllocateResource::Model::Hero }, reader: :private
  option :limit, type: Types::Integer, default: -> { 5 }, reader: :private

  def call(threat)
    matches = heroes.allocatable(limit).map do |hero|
      battle.new do |b|
        b.threat = threat
        b.hero = hero
        b.finished_at = FINISHER[threat.rank].call
        b.hero.touch # rubocop:disable Rails/SkipsModelValidations
      end
    end
    return matches if matches.count >= 2

    AppEvents.publish('insufficient.resources', threat:)
    raise StandardError, I18n.t(:insufficient_resources)
  end
end
