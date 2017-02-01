# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

module Database
  year = 2016
  SeasonBuilder.new.build(year)
  TeamBuilder.new.build(year)
  GameBuilder.new.build(year)
  PlayerBuilder.new.build(year)
  GameStatBuilder.new.build(year)
  QuarterStatBuilder.new.build(year)
end
