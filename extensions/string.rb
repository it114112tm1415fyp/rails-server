class String
	def ansi_reset
		ansi_escape(0)
	end
	def fc_n_black
		ansi_escape(30)
	end
	def fc_n_red
		ansi_escape(31)
	end
	def fc_n_green
		ansi_escape(32)
	end
	def fc_n_yellow
		ansi_escape(33)
	end
	def fc_n_blue
		ansi_escape(34)
	end
	def fc_n_purple
		ansi_escape(35)
	end
	def fc_n_cyan
		ansi_escape(36)
	end
	def fc_n_white
		ansi_escape(37)
	end
	def fc_b_black
		ansi_escape(90)
	end
	def fc_b_red
		ansi_escape(91)
	end
	def fc_b_green
		ansi_escape(92)
	end
	def fc_b_yellow
		ansi_escape(93)
	end
	def fc_b_blue
		ansi_escape(94)
	end
	def fc_b_purple
		ansi_escape(95)
	end
	def fc_b_cyan
		ansi_escape(96)
	end
	def fc_b_white
		ansi_escape(97)
	end
	def bc_n_black
		ansi_escape(40)
	end
	def bc_n_red
		ansi_escape(41)
	end
	def bc_n_green
		ansi_escape(42)
	end
	def bc_n_yellow
		ansi_escape(43)
	end
	def bc_n_blue
		ansi_escape(44)
	end
	def bc_n_purple
		ansi_escape(45)
	end
	def bc_n_cyan
		ansi_escape(46)
	end
	def bc_n_white
		ansi_escape(47)
	end
	def bc_b_black
		ansi_escape(100)
	end
	def bc_b_red
		ansi_escape(101)
	end
	def bc_b_green
		ansi_escape(102)
	end
	def bc_b_yellow
		ansi_escape(103)
	end
	def bc_b_blue
		ansi_escape(104)
	end
	def bc_b_purple
		ansi_escape(105)
	end
	def bc_b_cyan
		ansi_escape(106)
	end
	def bc_b_white
		ansi_escape(107)
	end
	def ansi_escape(code, inverse=0)
		"\e[#{code}m#{self}\e[#{inverse}m"
	end
end
