# frozen_string_literal: true

class Dashboard::Widgets::ThreatsDisabled::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :model, type: Types::Interface(:ms_raw_search), default: -> { Dashboard::Model::Threat }, reader: :private

  def call
    Try do
      filter_base = ["created_at > #{20.minutes.ago.to_time.to_i}"]
      threats = search_threats(['status != problem', *filter_base])
      disabled = search_threats(['status = disabled', *filter_base])

      build_metrics(disabled, threats)
    end
  end

  private

  def search_threats(filter)
    model.ms_raw_search('', page: 0, facets: [:rank], filter:)
  end

  def build_metrics(disabled, all)
    global = safe_pct(disabled["totalHits"], all["totalHits"], 0)
    metrics = { global: global, count: disabled["totalHits"] }

    disabled.dig("facetDistribution", "rank")&.each do |rank, value|
      total = all.dig("facetDistribution", "rank", rank) || 0
      metrics[rank] = safe_pct(value, total, 0)
    end

    metrics
  end

  def safe_pct(value, total, default = 0)
    (value.to_f / total * 100).round(0) rescue default
  end
end
