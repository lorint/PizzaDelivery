class Event
  include Mongoid::Document
  field :name, type: String
  field :date, type: Date
  field :start, type: Time
  field :end, type: Time
end
