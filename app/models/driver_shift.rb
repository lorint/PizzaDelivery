class DriverShift
  include Mongoid::Document
  belongs_to :driver
  belongs_to :shift

  has_many :orders
end
