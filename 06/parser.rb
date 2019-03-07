# Parses access input code; reads command, parses it, and provides access to fields
# and symbols. Removes whitespace and comments. 

load 'symbol_table.rb'
load 'code.rb'

class Parser

@@computation = {
	'0' => '0101010',
    '1' => '0111111',
   '-1' => '0111010',
    'D' => '0001100',
    'A' => '0110000',
   '!D' => '0001101',
   '!A' => '0110001',
   '-D' => '0001111',
   '-A' => '0110011',
  'D+1' => '0011111',
  'A+1' => '0110111',
  'D-1' => '0001110',
  'A-1' => '0110010',
  'D+A' => '0000010',
  'D-A' => '0010011',
  'A-D' => '0000111',
  'D&A' => '0000000',
  'D|A' => '0010101',
    'M' => '1110000',
   '!M' => '1110001',
   '-M' => '1110011',
  'M+1' => '1110111',
  'M-1' => '1110010',
  'D+M' => '1000010',
  'D-M' => '1010011',
  'M-D' => '1000111',
  'D&M' => '1000000',
  'D|M' => '1010101'
	}

@@destination = {
    '0' => '000',
    'M' => '001',
    'D' => '010',
   'MD' => '011',
    'A' => '100',
   'AM' => '101',
   'AD' => '110',
  'ADM' => '111'
	}

@@jump = {
    '0' => '000',
  'JGT' => '001',
  'JEQ' => '010',
  'JGE' => '011',
  'JLT' => '100',
  'JNE' => '101',
  'JLE' => '110',
  'JMP' => '111'
}

	def initialize(file)
		@input_file = File.open(file)
		@hack_file = File.open(file.split('.')[0] + '.hack', 'w')
		@table = SymbolTable.new()
		@parsed_array = []
	end

	def parse()

		# keeps track of label's position
		@incrementor = 0

		# iterates through each line to process labels
		@input_file.each do |line|
			next if line.strip[0] == '/'
			next if line.strip.empty?

			# if it is a label, strip it and add it to the symbol table
			# else push it to an array for later and increment 
			if commandType(line) == 'L_COMMAND'
				line = line.strip.gsub(/[()]/, "")
				@table.add_label(line, @incrementor)
			else
				@parsed_array.push(line)
				@incrementor += 1
			end
		end

		# iterate to remove comments, whitespace, etc.
		@parsed_array.each do |line|
			next if line.strip[0] == '('
			next if line.strip[0] == '/'
			next if line.strip.empty?
		
			string = ""

			line.split(//).each do |character|
				if character == '/'
					break
				else
					string += character
				end
			end

			# check if A_COMMAND & CONSTANT, A_COMMAND, OR C_COMMAND and write to hack file
			if ((commandType(line) == 'A_COMMAND') && (line.strip.split('@')[1].to_i.to_s == line.strip.split('@')[1]))
					puts ("%016b" % line.strip.split('@')[1])
					@hack_file.write(("%016b" % line.strip.split('@')[1]))
					@hack_file.puts
			elsif commandType(line) == 'A_COMMAND'
				puts ("%016b" % @table.add_entry(line.strip.split('@')[1]))
				@hack_file.write(("%016b" % @table.add_entry(line.strip.split('@')[1])))
				@hack_file.puts
			elsif commandType(line) == 'C_COMMAND'
				puts binary(c(string), d(string), j(string))
				@hack_file.write(binary(c(string), d(string), j(string)))
				@hack_file.puts
			end

			puts string
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
	def c(line)
		if line.include?('=')
			return @@computation[line.strip.split('=')[1]]
		elsif line.include?(';')
			return @@computation[line.strip.split(';')[0]]
		else
			return '0000000'
		end
	end

	def d(line)
		if line.include?('=')
			return @@destination[line.strip.split('=')[0]]
		else 
			return '000'
		end
	end

	def j(line)
		if line.include?(';')
			# check this statement; might be an error
			return @@jump[line.strip.split(';')[1]]
		else 
			return "000"
		end
	end	

	def binary(c, d, j)
		return ("111"+c+d+j)
	end

end