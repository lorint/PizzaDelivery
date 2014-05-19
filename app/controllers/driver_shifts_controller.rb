class DriverShiftsController < ApplicationController
	def index
		# We use an array here to reduce the number of queries presented to the database
		begin
			@shifts = Shift.all.to_a
		rescue Exception => ex
			puts "***** Driver Shift Controller error" + ex.message
			redirect_to errors_path
		end
	end
end
