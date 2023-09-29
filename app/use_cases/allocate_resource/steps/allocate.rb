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

    if threat.rank.to_i == first.hero.rank.to_i
      first.score!
      first.save!
      first.hero.working!
      publish('resource.allocated', threat: threat)
    elsif threat.rank.to_i == second.hero.rank.to_i
      second.score!
      second.save!
      second.hero.working!
      publish('resource.allocated', threat: threat)
    elsif threat.rank.to_i > first.hero.rank.to_i && threat.rank.to_i > second.hero.rank.to_i
      first.score!
      first.save!
      second.score!
      second.save!
      first.hero.working!
      second.hero.working!
      publish('resource.allocated', threat: threat)
    else
      publish('resource.not.allocated')
    end

    threat
  end
end
