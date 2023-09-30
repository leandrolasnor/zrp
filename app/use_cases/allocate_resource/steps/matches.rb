# frozen_string_literal: true

class AllocateResource::Steps::Matches
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :matcher, type: Interface(:find), default: -> { AllocateResource::Model::Battle }, reader: :private
  option :resources,
         type: Interface(:enabled, :page),
         default: -> { AllocateResource::Model::Hero }, reader: :private
  option :per_page, type: Integer, default: -> { 25 }, reader: :private
  option :time_to_end, type: Instance(Proc), default: -> { proc { TIMES[_1.rank].() } }

  def call(demand)
    finished_at = time_to_end.(demand)
    matches = promising.map { matcher.new(threat: demand, hero: _1, finished_at: finished_at) }
    return Success(matches) if matches.count >= 2

    Failure(I18n.t(:insufficient_resources))
  rescue StandardError => error
    Failure(error)
  end

  private

  def promising
    @promising ||= resources.enabled.page(1).per(per_page).order(:updated_at)
  end
end
