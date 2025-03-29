# frozen_string_literal: true

class AllocateResource::Steps::Matches
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :battle, type: Interface(:find), default: -> { AllocateResource::Model::Battle }, reader: :private
  option :heroes,
         type: Interface(:allocatable),
         default: -> { AllocateResource::Model::Hero }, reader: :private
  option :limit, type: Integer, default: -> { 5 }, reader: :private

  def call(threat)
    matches = heroes.allocatable(limit).map do |hero|
      battle.new do |b|
        b.threat = threat
        b.hero = hero
        b.finished_at = FINISHER[threat.rank].()
      end
    end
    return matches if matches.count >= 2

    raise StandardError.new(I18n.t(:insufficient_resources))
  end
end
