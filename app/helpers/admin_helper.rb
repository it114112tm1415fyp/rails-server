module AdminHelper
	def error_message_div
		@error_message.collect { |x| '<div class="error_message">' + "\n  " + x + "\n" + '</div>' }.join("\n").html_safe if @error_message
	end
	def warning_message_div
		@warning_message.collect { |x| '<div class="warning_message">' + "\n  " + x + "\n" + '</div>' }.join("\n").html_safe if @warning_message
	end
	def info_message_div
		@info_message.collect { |x| '<div class="info_message">' + "\n  " + x + "\n" + '</div>' }.join("\n").html_safe if @info_message
	end
end
