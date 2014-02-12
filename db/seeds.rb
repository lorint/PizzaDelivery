# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DriverShift.destroy_all
Availability.destroy_all
Driver.destroy_all
Shift.destroy_all
Order.destroy_all

l = Driver.create(name: "Larry")
# Larry can work on Tuesdays from 8pm until midnight
l.availabilities.create(day_of_week: 2, start_hour: 19, end_hour: 24)
# Same on Wednesday
l.availabilities.create(day_of_week: 3, start_hour: 20, end_hour: 24)
# And 6pm-3am on Saturday night
l.availabilities.create(day_of_week: 6, start_hour: 18, end_hour: 27)

m = Driver.create(name: "Martha")
# Martha can also work on Tuesdays from 8pm until midnight
m.availabilities.create(day_of_week: 2, start_hour: 20, end_hour: 24)
# Same on Thursday
m.availabilities.create(day_of_week: 4, start_hour: 20, end_hour: 24)
# And 6pm-3am on Friday night
m.availabilities.create(day_of_week: 5, start_hour: 18, end_hour: 27)
# And 9pm-1am on Saturday night
m.availabilities.create(day_of_week: 6, start_hour: 21, end_hour: 25)

# Now here's the various shifts we need to cover
#Tuesday
Shift.create(day_of_week: 2, start_hour: 19, end_hour: 24)
#Wednesday
Shift.create(day_of_week: 3, start_hour: 19, end_hour: 24)
#Thursday
Shift.create(day_of_week: 4, start_hour: 20, end_hour: 24)
#Friday
Shift.create(day_of_week: 5, start_hour: 18, end_hour: 27)
#Saturday
Shift.create(day_of_week: 6, start_hour: 18, end_hour: 27)

