# frozen_string_literal: true

namespace :metric do
  desc "Show some metrics"
  task show: :environment do
    metric = {
      battles: {
        total: AllocateResource::Model::Battle.count
      },
      threats: AllocateResource::Model::Threat.group(:status).count,
      heroes: AllocateResource::Model::Hero.group(:status).count
    }

    puts JSON.pretty_generate(metric)
  end
end
