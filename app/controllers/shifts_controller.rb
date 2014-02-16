class ShiftsController < ApplicationController
	def index
		@shifts = Shift.all
	end

	def update_individual
		shifts = Shift.each do |s|
			params.require(:shifts).permit!.each do |k,v|
				# If this shift's key is the same, update using these values
				s.update(v) if s.id.to_s == k
			end
		end
		#.reject { |s| s.errors.empty? }
#		puts @shifts
#		if @shifts.empty?
#			flash[:notice] = "Products updated"
#			redirect_to shifts_url
#		else
#			redirect_to shifts_url
#		end
	end
end
