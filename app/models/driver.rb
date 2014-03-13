class Driver
  include Mongoid::Document
  include Mongoid::Paperclip

  # Include this after_commit so that paperclip doesn't freak out
	def self.after_commit(*args, &block)
    args.each do |arg|
    case arg[:on]
      when :destroy
        after_destroy &block
      end
    end
  end
  
  field :name, type: String
  has_mongoid_attached_file :image,
   :styles => {
      :thumb => "100x100#",   # Centrally cropped
      :small  => "150x150>",  # Only squish if it's larger than this
      :elongate => "20x500"}

  has_many :driver_shifts
  has_many :availabilities
  accepts_nested_attributes_for :availabilities


  def available_shifts
    ret = []
    availabilities.each do |a|
      Shift.each do |s|
        if a.start_hour &&
          a.start_hour <= s.start_hour &&
          a.end_hour >= s.end_hour &&
          a.day_of_week == s.day_of_week
          ret.push s
          break # In case there are multiple availabilities that would match, we only need to represent it once
        end
      end
    end
    ret
  end

  def shifts
    DriverShift.where(driver_id: id).map do |ds|
      ds.shift
    end
  end

  def scheduled_hours
    hours = 0
    self.shifts.each do |s|
      hours += s.end_hour - s.start_hour
    end
    hours
  end

  def shift_ids
    shifts.map(&:id)
  end

  # The destroy_all way -- courtesy of John
  # def shift_ids=(list)
  #   DriverShift.where(driver_id: id).destroy_all
  #   list.each do |shift_id|
  #     unless shift_id.blank?
  #       self.driver_shifts.create(shift_id: shift_id)
  #     end
  #   end
  # end

  # Way that doesn't kill everything, but just adds and removes as necessary
  def shift_ids=(vals)
    my_ds = DriverShift.where(driver_id: self.id).map(&:shift_id)
    vals.each do |s|
      next if s.blank?
      s_id = BSON::ObjectId.from_string(s)
      if my_ds.include?(s_id)
        my_ds.delete(s_id)
      else
        self.driver_shifts.create(shift_id: s_id)
      end
    end
    my_ds.each do |r|
      DriverShift.find_by(driver_id: self.id, shift_id: r).destroy
    end
  end

	validates_attachment_content_type :image,
	 :content_type => /\Aimage\/.*\Z/
end
