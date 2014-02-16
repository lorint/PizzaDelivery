# The reason that this auto-loads is due to the config.autoload_paths line in application.rb
# It is used in the Shift model, as well as the application_helper.
module Util
	def hour_friendly(hourNum)
		ret = hourNum % 12
		(ret == 0 ? "12" : ret.to_s) + ((hourNum % 24) < 12 ? "AM" : "PM")
	end
end
