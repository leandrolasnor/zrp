# frozen_string_literal: true

class Dashboard::Widgets::AverageScore::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :model, type: Types::Interface(:ms_raw_search), default: -> { Dashboard::Model::Battle }, reader: :private
  option :numerator,
         type: Types::Instance(Proc),
         default: -> { proc { it['hits'].reduce(0) { |acc, battle| acc + battle['score'] } } }, reader: :private
  option :denominator, type: Types::Instance(Proc), default: -> { proc { it["totalHits"] } }, reader: :private

  def call
    Try do
      search = model.ms_raw_search(
        '',
        page: 1,
        hits_per_page: 1000,
        filter: ["finished_at > #{20.minutes.ago.to_time.to_i}"]
      )

      (numerator.(search).to_f / denominator.(search)).round(0)
    end
  end
end
