# frozen_string_literal: true

require 'rails/tasks'
Rake::Task['log:clear'].invoke if Rails.env.test?
