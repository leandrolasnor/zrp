# frozen_string_literal: true

class Dashboard::Widgets::BattlesLineup::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { Dashboard::Model::Threat }, reader: :private

  def call
    Try do
      lineup = model.ms_raw_search(
        '',
        page: 0,
        facets: [:lineup],
        filter: [
          'status NOT IN [problem, enabled]',
          "created_at > #{20.minutes.ago.to_time.to_i}"
        ]
      )

      [
        ['One Hero', ((lineup['facetDistribution']['lineup']['1'].to_f / lineup['totalHits']) * 100).round(0)],
        ['Two Heroes', ((lineup['facetDistribution']['lineup']['2'].to_f / lineup['totalHits']) * 100).round(0)]
      ]
    end
  end
end
