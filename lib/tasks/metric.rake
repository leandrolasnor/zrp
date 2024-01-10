# frozen_string_literal: true

namespace :metric do
  desc "Show some metrics"
  task show: :environment do
    res = Dashboard::Monad.new.()

    puts JSON.pretty_generate(res.value!)
  end
end
