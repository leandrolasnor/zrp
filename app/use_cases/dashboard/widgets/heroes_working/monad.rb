# frozen_string_literal: true

class Dashboard::Widgets::HeroesWorking::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { Dashboard::Model::Hero }, reader: :private

  def call
    Try do
      heroes = model.ms_raw_search('', page: 0, facets: [:rank], filter: ['status = enabled'])
      heroes_working = model.ms_raw_search('', page: 0, facets: [:rank], filter: ['status = working'])

      {
        global: (heroes_working["totalHits"] / heroes["totalHits"].to_f * 100).round(2),
        s: (heroes_working["facetDistribution"]["rank"]["s"] / heroes["facetDistribution"]["rank"]["s"].to_f * 100).round(2),
        a: (heroes_working["facetDistribution"]["rank"]["a"] / heroes["facetDistribution"]["rank"]["a"].to_f * 100).round(2),
        b: (heroes_working["facetDistribution"]["rank"]["b"] / heroes["facetDistribution"]["rank"]["b"].to_f * 100).round(2),
        c: (heroes_working["facetDistribution"]["rank"]["c"] / heroes["facetDistribution"]["rank"]["c"].to_f * 100).round(2),
        count: heroes_working["totalHits"]
      }
    end
  end
end
