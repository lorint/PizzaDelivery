module ApplicationHelper
	include Util
	# These are used in the _availability partial
	def day_array(add_pick)
		ret = (0..6).map {|num| [Date::DAYNAMES[num], num]}
		ret.unshift(["<< Pick >>",nil]) if add_pick
		ret
	end
	def hour_array(add_pick)
		ret = (11..27).map {|num| [hour_friendly(num), num]}
		ret.unshift(["<< >>",nil]) if add_pick
		ret
	end
end
