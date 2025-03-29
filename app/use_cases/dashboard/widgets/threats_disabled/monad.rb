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

      count = threats_disabled["totalHits"]
      global = (threats_disabled["totalHits"].to_f / threats["totalHits"] * 100).round(0) rescue 0
      metrics = { global: global, count: count }
      threats_disabled["facetDistribution"]["rank"].each do |k, v|
        metrics[k] = (v.to_f / threats["facetDistribution"]["rank"][k] * 100).round(0) rescue 0
      end

      metrics
    end
  end
end
