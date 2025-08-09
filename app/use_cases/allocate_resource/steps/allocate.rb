# frozen_string_literal: true

class AllocateResource::Steps::Allocate
  include Dry::Monads[:result]
  extend  Dry::Initializer

  option :tranks,
         type: Types::Instance(ActiveSupport::HashWithIndifferentAccess),
         default: -> { AllocateResource::Model::Threat.ranks },
         reader: :private

  option :hranks,
         type: Types::Instance(ActiveSupport::HashWithIndifferentAccess),
         default: -> { AllocateResource::Model::Hero.ranks },
         reader: :private

  def call(matches_sorted)
    ApplicationRecord.transaction do
      first = matches_sorted.first
      second = matches_sorted.second
      threat = matches_sorted.first.threat

      if tranks[threat.rank] == hranks[first.hero.rank]
        threat.working!
        first.hero.working!
        first.save!
      elsif tranks[threat.rank] == hranks[second.hero.rank]
        threat.working!
        second.hero.working!
        second.save!
      elsif tranks[threat.rank] > hranks[first.hero.rank] && tranks[threat.rank] > hranks[second.hero.rank]
        threat.working!
        first.hero.working!
        second.hero.working!
        first.save!
        second.save!
      end

      threat
    end
  end
end
