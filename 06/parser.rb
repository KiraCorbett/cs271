# Parses access input code; reads command, parses it, and provides access to fields
# and symbols. Removes whitespace and comments. 

class Parser

	# prepares to parse file
	def initialize(file)
		@input_file = File.open(file)
	end

	# differentiate the comp and dest components
	# if dest empty, remove '=', if comp empty, remove ';'
	def comp
		if current.include?('=')
		.split('=').last
		.split(';').first
	end

	def dest
			current
			current.split('=').first
		end
	end

	def jmp
		if current.include?(';')
			current.split(';').last
		end
	end

	def parse()
		# remove comments, blank lines, spaces
		@input_file.each do |line|
			line = line.gsub(/\s+|^$\n|\/\/.+/, "")
			puts line
		end
	end

end