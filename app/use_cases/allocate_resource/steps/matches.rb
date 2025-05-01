# frozen_string_literal: true

class AllocateResource::Steps::Matches
  include Dry::Monads[:result]
  include Dry::Events::Publisher[:insufficient_resources]
  extend  Dry::Initializer

  register_event 'insufficient.resources'

  option :battle, type: Types::Interface(:find), default: -> { AllocateResource::Model::Battle }, reader: :private
  option :heroes,
         type: Types::Interface(:allocatable),
         default: -> { AllocateResource::Model::Hero }, reader: :private
  option :limit, type: Types::Integer, default: -> { 5 }, reader: :private

  def call(threat)
    matches = heroes.allocatable(limit).map do |hero|
      hero.touch
      battle.new do |b|
        b.threat = threat
        b.hero = hero
        b.finished_at = FINISHER[threat.rank].()
      end
    end
    return matches if matches.count >= 2

    publish('insufficient.resources', threat: threat)
    raise StandardError, I18n.t(:insufficient_resources)
  end
end
