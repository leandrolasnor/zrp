# frozen_string_literal: true

TIMES = {
  0 => proc { rand(5.minutes.from_now..10.minutes.from_now) },
  1 => proc { rand(2.minutes.from_now..5.minutes.from_now) },
  2 => proc { rand(10.seconds.from_now..20.seconds.from_now) },
  3 => proc { rand(1.second.from_now..2.seconds.from_now) }
}.freeze
