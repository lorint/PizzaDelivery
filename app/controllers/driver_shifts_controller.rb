class DriverShiftsController < ApplicationController
	def index
		@shifts = Shift.all.to_a
	end
end
