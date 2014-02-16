class DriversController < ApplicationController

	def index
		@drivers = Driver.all
	end

	def new
		@driver = Driver.new
	end

	def create
		Driver.create(driver_params)
		redirect_to new_driver_path
	end

	def edit
		@driver = Driver.find(params[:id])
		3.times { @driver.availabilities.build }
	end

	def update
		d = Driver.find(params[:id])
		d.update(driver_params)
		redirect_to drivers_path
	end

private

	def driver_params
		params.require(:driver).permit(
			:name, :image,
			shift_ids: [],
			availabilities_attributes: [:day_of_week, :start_hour, :end_hour, :id]
		)
	end
end
