# frozen_string_literal: true

class AllocateResource::Steps::Matches
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :matcher, type: Interface(:find), default: -> { AllocateResource::Model::Battle }, reader: :private
  option :resources,
         type: Interface(:allocatable),
         default: -> { AllocateResource::Model::Hero }, reader: :private
  option :limit, type: Integer, default: -> { 5 }, reader: :private
  option :finisher, type: Instance(Proc), default: -> { proc { TIMES[_1.rank].() } }

  def call(demand)
    time_to_end = finisher.(demand)
    matches = resources.allocatable(limit).map { matcher.new(threat: demand, hero: _1, finished_at: time_to_end) }
    return matches if matches.count >= 2

    raise StandardError.new(I18n.t(:insufficient_resources))
  end
end
