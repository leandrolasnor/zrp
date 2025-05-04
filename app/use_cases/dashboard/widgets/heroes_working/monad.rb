# frozen_string_literal: true

class Dashboard::Widgets::HeroesWorking::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :model, type: Types::Interface(:ms_raw_search), default: -> { Dashboard::Model::Hero }, reader: :private

  def call
    Try do
      idle = model.ms_raw_search('', page: 0, facets: [:rank], filter: ['status != disabled'])
      working = model.ms_raw_search('', page: 0, facets: [:rank], filter: ['status = working'])

      {
        global: (working["totalHits"].to_f / idle["totalHits"] * 100).round(0),
        s: (working["facetDistribution"]["rank"]["s"].to_f / idle["facetDistribution"]["rank"]["s"] * 100).round,
        a: (working["facetDistribution"]["rank"]["a"].to_f / idle["facetDistribution"]["rank"]["a"] * 100).round,
        b: (working["facetDistribution"]["rank"]["b"].to_f / idle["facetDistribution"]["rank"]["b"] * 100).round,
        c: (working["facetDistribution"]["rank"]["c"].to_f / idle["facetDistribution"]["rank"]["c"] * 100).round,
        count: working["totalHits"]
      }
    end
  end
end
