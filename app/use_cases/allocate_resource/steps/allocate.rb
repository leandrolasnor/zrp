# frozen_string_literal: true

class AllocateResource::Steps::Allocate
  include Dry::Monads[:result]
  include Dry.Types()
  include Dry::Events::Publisher[:allocate_resource]
  extend  Dry::Initializer

  register_event 'resource.allocated'
  register_event 'resource.not.allocated'

  def call(matches)
    first = matches.first
    second = matches.second
    threat = matches.first.threat

    ApplicationRecord.transaction do
      second.hero.with_lock { second.hero.touch }
      first.hero.with_lock { first.hero.touch }
    end

    threat_ranks = AllocateResource::Model::Threat.ranks
    hero_ranks = AllocateResource::Model::Hero.ranks

    if threat_ranks[threat.rank] == hero_ranks[first.hero.rank]
      ApplicationRecord.transaction do
        first.hero.with_lock do
          first.hero.working!
          first.score!
          first.save!
        end
        threat.with_lock { threat.working! }
        publish('resource.allocated', threat: threat)
      end
    elsif threat_ranks[threat.rank] == hero_ranks[second.hero.rank]
      ApplicationRecord.transaction do
        second.hero.with_lock do
          second.hero.working!
          second.score!
          second.save!
        end
        threat.with_lock { threat.working! }
        publish('resource.allocated', threat: threat)
      end
    elsif threat_ranks[threat.rank] > hero_ranks[first.hero.rank] && threat_ranks[threat.rank] > hero_ranks[second.hero.rank]
      ApplicationRecord.transaction do
        first.hero.with_lock do
          first.hero.working!
          first.score!
          first.save!
        end
        second.hero.with_lock do
          second.hero.working!
          second.score!
          second.save!
        end
        threat.with_lock { threat.working! }
        publish('resource.allocated', threat: threat)
      end
    else
      publish('resource.not.allocated')
    end

    threat
  end
end
