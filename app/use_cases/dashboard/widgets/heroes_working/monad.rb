# frozen_string_literal: true

class Dashboard::Widgets::HeroesWorking::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :model, type: Types::Interface(:ms_raw_search), default: -> { Dashboard::Model::Hero }, reader: :private

  def call
    Try do
      idle = model.ms_raw_search('', page: 0, facets: [:rank], filter: ['status != disabled'])
      working = model.ms_raw_search('', page: 0, facets: [:rank], filter: ['status = working'])

      build_metrics(working, idle)
    end
  end

  private

  def build_metrics(working, idle)
    {
      global: rank_pct(working["totalHits"], idle["totalHits"], 0),
      s: rank_pct(facet(working, :s), facet(idle, :s)),
      a: rank_pct(facet(working, :a), facet(idle, :a)),
      b: rank_pct(facet(working, :b), facet(idle, :b)),
      c: rank_pct(facet(working, :c), facet(idle, :c)),
      count: working["totalHits"]
    }
  end

  def facet(result, rank)
    result.dig("facetDistribution", "rank", rank.to_s) || 0
  end

  def rank_pct(value, total, round_mode = :round)
    (value.to_f / total * 100).public_send(round_mode)
  end
end
