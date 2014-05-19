class AvailabilitiesController < ApplicationController
	def destroy
		a = Availability.find(params[:id])
		driver_id = a.driver.id
		a.destroy
		redirect_to edit_driver_path driver_id
	end
end
