# frozen_string_literal: true

module Http::ThreatsHistory
  class Serializer < ActiveModel::Serializer
    attributes :id, :name, :rank, :lat, :lng, :battle

    def battle = BattleSerializer.new(object)
  end

  class BattleSerializer < ActiveModel::Serializer
    attributes :heroes, :score, :duration, :finished_at, :created_at

    def duration
      diff = object.battles.first.finished_at - object.battles.first.created_at
      ActiveSupport::Duration.build(diff).parts
    end

    def heroes = object.heroes.map { HeroSerializer.new(it) }
    def score = object.battles.map(&:score).max
    def finished_at = object.battles.first.finished_at
    def created_at = object.battles.first.created_at
  end

  class HeroSerializer < ActiveModel::Serializer
    attributes :name, :rank, :lat, :lng
  end
end
