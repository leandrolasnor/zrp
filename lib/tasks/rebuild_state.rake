# frozen_string_literal: true

namespace :rebuild do
  desc 'Rebuild read models from RES events'
  task state: :environment do
    RebuildState.call
    puts 'Read models rebuilt from RES events.'
  end
end
