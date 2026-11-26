# frozen_string_literal: true

class Dashboard::Widgets::BattlesLineup::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :model, type: Types::Interface(:ms_raw_search), default: -> { Dashboard::Model::Threat }, reader: :private

  def call
    Try { build_metrics(search) }
  end

  private

  def search
    model.ms_raw_search(
      '',
      page: 0,
      facets: [:lineup],
      filter: [
        'status NOT IN [problem, enabled]',
        "created_at > #{20.minutes.ago.to_time.to_i}"
      ]
    )
  end

  def build_metrics(result)
    total = result['totalHits'].to_i
    distribution = result.dig('facetDistribution', 'lineup') || {}

    {
      lineup: [
        ['One Hero', percentage(distribution['1'], total)],
        ['Two Heroes', percentage(distribution['2'], total)]
      ],
      count: total
    }
  end

  def percentage(value, total)
    return 0 if total.zero?

    (value.to_f / total * 100).round(0)
  end
end
