class Order
  include Mongoid::Document
  field :order_date, type: Time
  belongs_to :driver_shift
end
