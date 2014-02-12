class Driver
  include Mongoid::Document
  field :name, type: String

  has_many :driver_shifts
  has_many :availabilities
end
