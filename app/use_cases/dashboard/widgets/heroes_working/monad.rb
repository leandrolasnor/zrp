# frozen_string_literal: true

class Dashboard::Widgets::HeroesWorking::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { Dashboard::Model::Hero }, reader: :private

  def call
    Try do
      heroes = model.ms_raw_search('', page: 0, facets: [:rank], filter: ['status != disabled'])
      heroes_working = model.ms_raw_search('', page: 0, facets: [:rank], filter: ['status = working'])

      {
        global: (heroes_working["totalHits"].to_f / heroes["totalHits"] * 100).round(0),
        s: (heroes_working["facetDistribution"]["rank"]["s"].to_f / heroes["facetDistribution"]["rank"]["s"] * 100).round(0),
        a: (heroes_working["facetDistribution"]["rank"]["a"].to_f / heroes["facetDistribution"]["rank"]["a"] * 100).round(0),
        b: (heroes_working["facetDistribution"]["rank"]["b"].to_f / heroes["facetDistribution"]["rank"]["b"] * 100).round(0),
        c: (heroes_working["facetDistribution"]["rank"]["c"].to_f / heroes["facetDistribution"]["rank"]["c"] * 100).round(0),
        count: heroes_working["totalHits"]
      }
    end
  end
end
