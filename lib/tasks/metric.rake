# frozen_string_literal: true

namespace :metric do
  desc "Show some metrics"
  task show: :environment do
    metric = {
      battles: {
        total: AllocateResource::Model::Battle.count
      },
      threats: {
        problem: AllocateResource::Model::Threat.problem.count,
        enabled: AllocateResource::Model::Threat.enabled.count,
        disabled: AllocateResource::Model::Threat.disabled.count,
        total: AllocateResource::Model::Threat.count
      },
      heroes: {
        enabled: AllocateResource::Model::Hero.enabled.count,
        working: AllocateResource::Model::Hero.working.count
      }
    }

    puts Time.zone.now
    puts JSON.pretty_generate(metric)
  end
end
