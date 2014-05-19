class Availability
  include Mongoid::Document
  field :day_of_week, type: Integer
  field :start_hour, type: Integer
  field :end_hour, type: Integer
  belongs_to :driver

  validates :day_of_week, presence: true
  validates :start_hour, presence: true
  validates :end_hour, presence: true
  validate :no_overlap?

	# If there are any shifts that were used by this availability, they're also outta here!
	before_destroy :check_shifts
	def check_shifts
		s = self.driver.find_shift(self)
		s.destroy if s
	end

  # See if there's any other availability that would collide with this one
	def no_overlap?
		# Same driver and day, and not this same exact record
		# And is either the start hour less than the end hour,
		# or the end hour greater than the start hour?
		a = Availability.where(driver_id: driver_id,	#Same driver
		 day_of_week: day_of_week,	# Same day
		 id: {"$ne" => id}).or(	# Not this same record we're trying to save
			start_hour: {"$lt" => end_hour}).or(	# Does the start hour overlap?
			end_hour: {"$gt" => start_hour})	# Or the end hour?
		a.count == 0
	end
end
