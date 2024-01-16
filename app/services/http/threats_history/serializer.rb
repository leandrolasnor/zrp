# frozen_string_literal: true

class Http::ThreatsHistory::Serializer < ActiveModel::Serializer
  attributes :name, :rank, :lat, :lng, :battle

  def battle
    BattleSerializer.new(object)
  end
end

class BattleSerializer < ActiveModel::Serializer
  attributes :heroes, :score, :duration, :finished_at, :created_at

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

  def finished_at
    object.battles.first.finished_at
  end

  def created_at
    object.battles.first.created_at
  end
end

class HeroSerializer < ActiveModel::Serializer
  attributes :name, :rank, :lat, :lng
end
