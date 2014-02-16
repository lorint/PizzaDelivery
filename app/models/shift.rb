class Shift
  include Mongoid::Document
  include Util
  
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

  def drivers
    DriverShift.where(shift_id: id).map do |ds|
      ds.driver
    end
  end

	def driver_ids
		drivers.map(&:id)
	end

  # Add and remove as necessary
  def driver_ids=(vals)
    my_ds = DriverShift.where(shift_id: self.id).map(&:driver_id)
    vals.each do |d|
      next if d.blank?
      d_id = BSON::ObjectId.from_string(d)
      if my_ds.include?(d_id)
        my_ds.delete(d_id)
      else
        self.driver_shifts.create(driver_id: d_id)
      end
    end
    my_ds.each do |r|
      DriverShift.find_by(driver_id: self.id, shift_id: r).destroy
    end
  end


	def to_s
		Date::DAYNAMES[day_of_week] + " " + hour_friendly(start_hour) + "-" + hour_friendly(end_hour)
	end
end
