# frozen_string_literal: true

class Dashboard::Widgets::ThreatsDisabled::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { Dashboard::Model::Threat }, reader: :private

  def call
    Try do
      threats = model.ms_raw_search(
        '',
        page: 0,
        facets: [:rank],
        filter: [
          'status != problem',
          "created_at > #{20.minutes.ago.to_time.to_i}"
        ]
      )
      threats_disabled = model.ms_raw_search(
        '',
        page: 0,
        facets: [:rank],
        filter: [
          'status = disabled',
          "created_at > #{20.minutes.ago.to_time.to_i}"
        ]
      )

      global = (threats_disabled["totalHits"].to_f / threats["totalHits"] * 100).round(0) rescue 0
      god = (threats_disabled["facetDistribution"]["rank"]["god"].to_f / threats["facetDistribution"]["rank"]["god"] * 100).round(0) rescue 0
      dragon = (threats_disabled["facetDistribution"]["rank"]["dragon"].to_f / threats["facetDistribution"]["rank"]["dragon"] * 100).round(0) rescue 0
      tiger = (threats_disabled["facetDistribution"]["rank"]["tiger"].to_f / threats["facetDistribution"]["rank"]["tiger"] * 100).round(0) rescue 0
      wolf = (threats_disabled["facetDistribution"]["rank"]["wolf"].to_f / threats["facetDistribution"]["rank"]["wolf"] * 100).round(0) rescue 0

      { global: global, god: god, dragon: dragon, tiger: tiger, wolf: wolf, count: threats_disabled["totalHits"] }
    end
  end
end
