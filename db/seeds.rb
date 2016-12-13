# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
location = Location.create(name: 'BangloreHAL', state: 'Karnataka', city: 'Banglore'
  , street_first: '1st cross, Wind Tunnel Rd.', street_second: 'Menzo-baran-zen'
  , default_location: true, opening_time: 10.hours.ago, closing_time: Time.now)
