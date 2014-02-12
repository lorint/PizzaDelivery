class DriverShiftsController < ApplicationController
	def index
		@shifts = Shift.all.to_a
		@shifts.each do |s|
			class << s
				attr_accessor :available_drivers
			end
			# Here's the WHERE query that we wrote in class:
			driver_ids = Availability.where(
				start_hour: {"$lte" => 21},
				end_hour: {"$gte" => 24},
				day_of_week: 6).map(&:driver_id)
			# Grab an array of all drivers with the above schedule
			s.available_drivers = Driver.find(driver_ids)
		end
	end
end
