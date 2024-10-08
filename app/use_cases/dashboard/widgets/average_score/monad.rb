# frozen_string_literal: true

class Dashboard::Widgets::AverageScore::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { Dashboard::Model::Battle }, reader: :private
  option :numerator,
         type: Instance(Proc),
         default: -> { proc { _1['hits'].reduce(0) { |acc, battle| acc + battle['score'] } } }, reader: :private
  option :denominator, type: Instance(Proc), default: -> { proc { _1["totalHits"] } }, reader: :private

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
