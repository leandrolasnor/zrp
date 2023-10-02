# frozen_string_literal: true

class Http::ThreatsHistory::Serializer < ActiveModel::Serializer
  attributes :name, :rank, :lat, :lng, :battle

  def battle
    BattleSerializer.new(object)
  end
end

class BattleSerializer < ActiveModel::Serializer
  attributes :heroes, :score, :duration

  def heroes
    object.heroes.map do
      HeroSerializer.new(_1)
    end
  end

  def score
    object.battles.map { _1.score }.max
  end

  def duration
    diff = object.battles.first.finished_at - object.battles.first.created_at
    ActiveSupport::Duration.build(diff).parts
  end
end

class HeroSerializer < ActiveModel::Serializer
  attributes :name, :rank, :lat, :lng
end
