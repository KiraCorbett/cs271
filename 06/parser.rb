# Parses access input code; reads command, parses it, and provides access to fields
# and symbols. Removes whitespace and comments. 

load 'symbol_table.rb'
load 'code.rb'

class Parser

@@computation = {
		'0' => '101010',
    '1' => '111111',
   '-1' => '111010',
    'D' => '001100',
    'A' => '110000',
   '!D' => '001101',
   '!A' => '110001',
   '-D' => '001111',
   '-A' => '110011',
  'D+1' => '011111',
  'A+1' => '110111',
  'D-1' => '001110',
  'A-1' => '110010',
  'D+A' => '000010',
  'D-A' => '010011',
  'A-D' => '000111',
  'D&A' => '000000',
  'D|A' => '010101',
    'M' => '110000',
   '!M' => '110001',
   '-M' => '110011',
  'M+1' => '110111',
  'M-1' => '110010',
  'D+M' => '000010',
  'D-M' => '010011',
  'M-D' => '000111',
  'D&M' => '000000',
  'D|M' => '010101'
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

			# if A_COMMAND and constant
			if ((commandType(line) == 'A_COMMAND') && (line.strip.split('@')[1].to_i.to_s == line.strip.split('@')[1]))
					#line.to_s(2).rjust(16, '0')
					#puts line.strip.split('@')[1].to_s.rjust(16, '0')
					puts ("%015b" % line.strip.split('@')[1])
			elsif commandType(line) == 'A_COMMAND'
				@table.addEntry(line)
				puts "A COMMAND"
			else
				#puts binary(c(line), d(line), j(line))
				puts c(line)
				#puts ("%015b" % line.strip.split('@')[1])
				puts "C COMMAND"
			end

			# number.to_s(2).rjust(16, '0')


			puts line
			puts commandType(line)
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
			#puts @@computation[line]
			#puts "cline"
		elsif line.include?(';')
			return @@jump[line.strip.split(';')[0]]
			#puts @@jump[line]
			#puts "cline"
		else
			'000000'
		end
	end

	def d(line)
		if line.include? '='
			#@destination[line.split('=').first]
		end
	end

	def j(line)
		if line.include? ';'
			#@jump[line.split(';').last]
		else
			return "000"
		end
	end	

	def binary(c, d, j)
		return ("111"+c+d+j)
	end

end