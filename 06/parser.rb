# Parses access input code; reads command, parses it, and provides access to fields
# and symbols. Removes whitespace and comments. 

class Parser

	# prepares to parse file
	def initialize(file)
		@input_file = File.open(file)
	end

	# remove comments, blank lines, spaces
	def parse()
		@input_file.each do |line|
			next if line.strip[0] == '('
			next if line.strip[0] == '/'
			next if line.strip.empty?

			puts line
			puts commandType(line)
		end
	end

	# returns type of command
	def commandType(line)
		if line.strip[0] == '@'
			'A_COMMAND'
		elsif line.strip[0] == '('
			'L_COMMAND'
		else
			'C_COMMAND'
		end
	end

	# differentiate the comp and dest components
	# if dest empty, remove '=', if comp empty, remove ';'
	def dest(line)
		if line.include?('=')
			line.split('=').first
		end
	end

	def comp(line)
		line.split('=').last
		line.split(';').first
	end

	def jmp(line)
		if line.include?(';')
			line.split(';').last
		end
	end	

end