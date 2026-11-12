# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

30.times do
  FactoryBot.create(
    :hero,
    :create_hero,
    name: Faker::Name.unique.name,
    rank: %i[c b a s].sample,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude
  )
end
