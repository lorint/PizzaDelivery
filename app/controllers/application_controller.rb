class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :hour_friendly

	def hour_friendly(hourNum)
		ret = hourNum % 12
		(ret == 0 ? "12" : ret.to_s) + ((hourNum % 24) < 12 ? "AM" : "PM")
	end

end
