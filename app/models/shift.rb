class Shift
  include Mongoid::Document
  field :day_of_week, type: Integer
  field :start_hour, type: Integer
  field :end_hour, type: Integer

  has_many :driver_shifts

  def available_drivers
		driver_ids = Availability.where(
			start_hour: {"$lte" => start_hour},
			end_hour: {"$gte" => end_hour},
			day_of_week: day_of_week).map(&:driver_id)
		# Grab an array of all drivers with the above schedule
		Driver.find(driver_ids)
	end

	def to_s
		Date::DAYNAMES[day_of_week] + " " + hour_friendly(start_hour) + "-" + hour_friendly(end_hour)
	end

	def hour_friendly(hourNum)
		ret = hourNum % 12
		(ret == 0 ? "12" : ret.to_s) + ((hourNum % 24) < 12 ? "AM" : "PM")
	end

end
