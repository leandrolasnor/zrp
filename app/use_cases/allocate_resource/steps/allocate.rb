# frozen_string_literal: true

class AllocateResource::Steps::Allocate
  include Dry::Monads[:result]
  include Dry.Types()
  extend  Dry::Initializer

  option :tranks,
         type: Instance(ActiveSupport::HashWithIndifferentAccess),
         default: -> { AllocateResource::Model::Threat.ranks },
         reader: :private

  option :hranks,
         type: Instance(ActiveSupport::HashWithIndifferentAccess),
         default: -> { AllocateResource::Model::Hero.ranks },
         reader: :private

  def commit(battle)
    ApplicationRecord.transaction do
      battle.hero.with_lock do
        battle.hero.touch
        battle.hero.working!
        battle.threat.with_lock { battle.threat.working! } if battle.threat.enabled?
        battle.save!
      end
    end
  end

  def call(matches_sorted)
    first = matches_sorted.first
    second = matches_sorted.second
    threat = matches_sorted.first.threat

    if tranks[threat.rank] == hranks[first.hero.rank]
      commit(first)
    elsif tranks[threat.rank] == hranks[second.hero.rank]
      commit(second)
    elsif tranks[threat.rank] > hranks[first.hero.rank] && tranks[threat.rank] > hranks[second.hero.rank]
      [first, second].each { commit(it) }
    end

    threat.reload
  end
end
