# frozen_string_literal: true

class AllocateResource::Steps::Allocate
  include Dry::Monads[:result]
  include Dry.Types()
  include Dry::Events::Publisher[:allocate_resource]
  extend  Dry::Initializer

  option :threat_ranks,
         type: Instance(ActiveSupport::HashWithIndifferentAccess),
         default: -> { AllocateResource::Model::Threat.ranks },
         reader: :private

  option :hero_ranks,
         type: Instance(ActiveSupport::HashWithIndifferentAccess),
         default: -> { AllocateResource::Model::Hero.ranks },
         reader: :private

  register_event 'resource.allocated'
  register_event 'resource.not.allocated'

  def call(matches_sorted)
    first = matches_sorted.first
    second = matches_sorted.second
    threat = matches_sorted.first.threat

    ApplicationRecord.transaction do
      second.hero.with_lock { second.hero.touch }
      first.hero.with_lock { first.hero.touch }
    end

    if threat_ranks[threat.rank] == hero_ranks[first.hero.rank]
      ApplicationRecord.transaction do
        first.hero.with_lock do
          first.hero.working!
          first.save!
        end
        threat.with_lock { threat.working! }
        publish('resource.allocated', threat: threat)
      end
    elsif threat_ranks[threat.rank] == hero_ranks[second.hero.rank]
      ApplicationRecord.transaction do
        second.hero.with_lock do
          second.hero.working!
          second.save!
        end
        threat.with_lock { threat.working! }
        publish('resource.allocated', threat: threat)
      end
    elsif threat_ranks[threat.rank] > hero_ranks[first.hero.rank] && threat_ranks[threat.rank] > hero_ranks[second.hero.rank]
      ApplicationRecord.transaction do
        first.hero.with_lock do
          first.hero.working!
          first.save!
        end
        second.hero.with_lock do
          second.hero.working!
          second.save!
        end
        threat.with_lock { threat.working! }
        publish('resource.allocated', threat: threat)
      end
    else
      publish('resource.not.allocated', threat: threat)
    end

    threat
  end
end
