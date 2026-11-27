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

    one_hero = distribution.fetch('1', 0).to_i
    two_heroes = distribution.fetch('2', 0).to_i

    # O índice tem uma threat por hit, mas uma threat com dois heróis gera
    # duas battles. Cada threat com lineup = 2 contribui com uma battle extra.
    count = total + two_heroes

    {
      lineup: [
        ['One Hero', percentage(one_hero, total)],
        ['Two Heroes', percentage(two_heroes, total)]
      ],
      count:
    }
  end

  def percentage(value, total)
    return 0 if total.zero?

    (value.to_f / total * 100).round(0)
  end
end
