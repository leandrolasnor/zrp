# frozen_string_literal: true

class AllocateResource::DomainService::Calculator::Battle
  include Dry.Types()
  extend Dry::Initializer

  HALF = 20037.5 # half_equatorial_circumference(km)

  param :battle, type: Instance(AllocateResource::Model::Battle), reader: :private
  option :hero, type: Instance(AllocateResource::Model::Hero), default: -> { battle.hero }, reader: :private
  option :threat, type: Instance(AllocateResource::Model::Threat), default: -> { battle.threat }, reader: :private

  option :calculator,
         type: Instance(Proc),
         default: -> { proc { Geocoder::Calculations.distance_between(_1, _2) } },
         reader: :private

  option :hero_points, type: Strict::Array.of(Decimal), default: -> { [hero.lat, hero.lng] }, reader: :private
  option :threat_points,
         type: Strict::Array.of(Decimal),
         default: -> { [threat.lat, threat.lng] },
         reader: :private
  option :distance,
         type: Strict::Integer,
         default: -> { calculator.(hero_points, threat_points).to_i },
         reader: :private

  option :d, type: Strict::Integer.constrained(lteq: 100, gteq: 0),
             default: -> { ((distance / HALF) * 100).round },
             reader: :private

  option :nv, type: Strict::Integer, default: -> { hero.rank.to_i }, reader: :private
  option :nc, type: Strict::Integer, default: -> { threat.rank.to_i }, reader: :private
  option :ratio,
         type: Strict::Integer,
         default: -> { 100 / AllocateResource::Model::Threat.ranks.values.last },
         reader: :private

  option :n,
         type: Strict::Integer.constrained(lteq: 100, gteq: 0),
         default: -> { 100 - (ratio * (nv - nc).abs) },
         reader: :private

  def score!
    battle.score = calculate_score
    calculate_score
  end

  private

  def calculate_score = @calculate_score ||= ((n + d) / 2).to_i
end
