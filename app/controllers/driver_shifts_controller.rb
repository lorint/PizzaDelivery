class DriverShiftsController < ApplicationController
	def index
		# We use an array here to reduce the number of queries presented to the database
		@shifts = Shift.all.to_a
	end
end
