# frozen_string_literal: true

class Dashboard::Widgets::ThreatsDistribution::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { Dashboard::Model::Threat }, reader: :private
  option :ranks, type: Array, default: -> { model.ranks.keys }, reader: :private

  def call
    Try do
      search = model.ms_raw_search(
        '',
        page: 0,
        facets: [:rank],
        filter: ["status NOT IN [problem]", "created_at > #{20.minutes.ago.to_time.to_i}"]
      )

      dist = search['facetDistribution']['rank']
      count = ranks.map { [_1, dist[_1]] }

      count.to_h.symbolize_keys
    end
  end
end
