# frozen_string_literal: true

ActiveJob::Uniqueness.configure { it.on_conflict = :log }
