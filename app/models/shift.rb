class Shift
  include Mongoid::Document
  include Util
  
  field :day_of_week, type: Integer
  field :start_hour, type: Integer
  field :end_hour, type: Integer
  field :num_drivers, type: Integer

  has_many :driver_shifts

  # Note that this returns a bastardized version of Driver objects...
  # The IDs are not solely driver IDs, but rather driver ID, an underscore, and then shift ID.
  # This is so our janky routine to do UPDATEs can work.

  # %%% We should probably just use driver_shift objects instead!!
  def available_drivers(is_unscheduled)
		driver_ids = Availability.where(
			start_hour: {"$lte" => start_hour},
			end_hour: {"$gte" => end_hour},
			day_of_week: day_of_week).map(&:driver_id)
    if is_unscheduled
      driver_ids -= self.driver_shifts.map(&:driver_id)
    end
		# Grab an array of all drivers with the above schedule
    # And formulate custom IDs that include the shift ID
		Driver.find(driver_ids).map{|d| Driver.new(id: d.id.to_s+"_"+self.id.to_s, name: d.name)}
	end

  def drivers
    DriverShift.where(shift_id: id).map do |ds|
      ds.driver
    end
  end

  # This format of ID jives with the available_drivers method above
  # so Rails can automatically select checkboxes as appropriate
	def driver_ids
		drivers.map{|d| d.id.to_s + "_" + self.id.to_s}
	end

  # Add and remove as necessary
  # This takes in a list of driver / shift combo IDs
  def driver_ids=(vals)
    puts "***************"+ vals.inspect

    my_ds = DriverShift.all.map{|x| x.driver_id.to_s + "_" + x.shift_id.to_s}
    vals.each do |ds|
      next if ds.blank?
      parts = vals.split("_")
      d_id = BSON::ObjectId.from_string(parts[0])
      s_id = BSON::ObjectId.from_string(parts[1])
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

  def self.hour_range
    start_hour = 999
    end_hour = 0
    # Find the minimum start hour, and max end hour
    Shift.all.each do |s|
      start_hour = s.start_hour if start_hour > s.start_hour
      end_hour = s.end_hour if end_hour < s.end_hour
    end
    start_hour..end_hour
  end

end
