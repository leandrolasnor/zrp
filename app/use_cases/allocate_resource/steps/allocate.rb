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

    first.hero.touch
    second.hero.touch

    threat_ranks = AllocateResource::Model::Threat.ranks
    hero_ranks = AllocateResource::Model::Hero.ranks

    if threat_ranks[threat.rank] == hero_ranks[first.hero.rank]
      first.score!
      first.save!
      first.hero.lock!.working!
      publish('resource.allocated', threat: threat)
    elsif threat_ranks[threat.rank] == hero_ranks[second.hero.rank]
      second.score!
      second.save!
      second.hero.lock!.working!
      publish('resource.allocated', threat: threat)
    elsif threat_ranks[threat.rank] > hero_ranks[first.hero.rank] && threat_ranks[threat.rank] > hero_ranks[second.hero.rank]
      first.score!
      first.save!
      second.score!
      second.save!
      first.hero.lock!.working!
      second.hero.lock!.working!
      publish('resource.allocated', threat: threat)
    else
      publish('resource.not.allocated')
    end

    threat
  end
end
