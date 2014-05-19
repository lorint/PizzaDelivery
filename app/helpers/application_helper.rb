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

	# A button that doesn't suffer from the same crazy form-in-a-form problem that normal buttons do
	def button_to_link(name, link, options={})
	  confirm_option = options.delete(:confirm)
	  popup_option = options.delete(:popup)
	  link_function = popup_option ? redirect_function(link, :new_window => true) : redirect_function(link)
	  link_function = "if (confirm('#{escape_javascript(confirm_option)}')) { #{link_function}; }" if confirm_option
	  button_to_function name, link_function, options
	end

	def redirect_function(location, options={})
	  location = location.is_a?(String) ? location : url_for(location)
	  if options[:new_window]
	    %|window.open('#{location}')|
	  else
	    %|{window.location.href='#{location}'}|
	  end
	end

end
