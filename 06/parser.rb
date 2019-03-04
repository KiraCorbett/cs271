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

  #symbolTable = symbol_table.new
  #coder = code.new

	# prepares to parse file
	def initialize(file)
		@input_file = File.open(file)
		@table = SymbolTable.new()
	end

	# remove comments, blank lines, spaces
	def parse()
		@input_file.each do |line|
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


			# if A_COMMAND and constant
			if ((commandType(line) == 'A_COMMAND') && (line.strip.split('@')[1].to_i.to_s == line.strip.split('@')[1]))
					#line.to_s(2).rjust(16, '0')
					#puts line.strip.split('@')[1].to_s.rjust(16, '0')
					#puts ("%016b" % line.strip.split('@')[1])
			elsif commandType(line) == 'A_COMMAND'
				@table.addEntry(line)
				#puts "A COMMAND"
			elsif commandType(line) == 'C_COMMAND'
				puts binary(c(string), d(string), j(string))
				#puts ("%015b" % line.strip.split('@')[1])
				#puts "C COMMAND"
			end
			# number.to_s(2).rjust(16, '0')

			puts string
			#puts commandType(line)
		end
	end

	# main_computation function for code.rb and store information variable

	# If A command and just a number
  # 	convert number to binary
  # elsif A command and symbol
  # 	throw symbol through symbol table and convert resulting number to binary
	# elsif C command
  # => do c command stuff

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
			return '000000'
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