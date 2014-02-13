class Driver
  include Mongoid::Document
  include Mongoid::Paperclip

  attr_accessor :shift_ids

	def self.after_commit(*args, &block)
    args.each do |arg|
    case arg[:on]
      when :destroy
        after_destroy &block
      end
    end
  end

  def available_shifts
    ret = []
    availabilities.each do |a|
      Shift.each do |s|
        if a.start_hour <= s.start_hour &&
          a.end_hour >= s.end_hour &&
          a.day_of_week == s.day_of_week
          ret.push s
        end
      end
    end
    ret
  end

  def shift_ids=(val)
    add_these = []
    remove_these = Shift.all.map(&:_id)
    Shift.each do |s|
      if val.include?(s.id.to_s)
        remove_these.delete(s.id)
      else
        self.driver_shifts.create(shift: s)
      end
    end
    remove_these.each do |r|
      DriverShift.find_by(driver: self, shift_id: r).destroy
    end
  end

  field :name, type: String
	has_mongoid_attached_file :image,
	 :styles => {
      :thumb => "100x100#",		# Centrally cropped
      :small  => "150x150>",	# Only squish if it's larger than this
      :elongate => "20x500"}

  has_many :driver_shifts
  has_many :availabilities

	validates_attachment_content_type :image,
	 :content_type => /\Aimage\/.*\Z/
end
