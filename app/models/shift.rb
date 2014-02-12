class Shift
  include Mongoid::Document
  field :day_of_week, type: Integer
  field :start_hour, type: Integer
  field :end_hour, type: Integer

  has_many :driver_shifts
end
