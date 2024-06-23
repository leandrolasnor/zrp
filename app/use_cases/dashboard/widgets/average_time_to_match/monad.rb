# frozen_string_literal: true

class Dashboard::Widgets::AverageTimeToMatch::Monad
  include Dry::Monads[:try]
  include Dry.Types()
  extend Dry::Initializer

  option :model, type: Interface(:ms_raw_search), default: -> { Dashboard::Model::Battle }, reader: :private
  option :duration, type: Instance(Proc), default: -> { proc { ActiveSupport::Duration.build(_1).parts } }
  option :numerator,
         type: Instance(Proc),
         default: -> {
                    proc {
                      product_time = _1['hits'].reduce(1) do |acc, battle|
                        battle['time_to_match'].positive? ? acc * battle['time_to_match'] : acc
                      end
                      product_time**(1.to_f / _1['totalHits'])
                    }
                  }, reader: :private
  option :denominator, type: Instance(Proc), default: -> { proc { 1 } }, reader: :private

  def call
    Try do
      search = model.ms_raw_search(
        '',
        page: 1,
        hits_per_page: 1000,
        filter: ["finished_at > #{20.minutes.ago.to_time.to_i}"]
      )

      duration.((numerator.(search).to_f / denominator.(search)))
    end
  end
end
