# Manages the symbol table

class SymbolTable

	def initialize
		@symbolsTable = {
		  # "SP" => "0",
		  'SP'   => 0,
		  'LCL'  => 1,
		  'ARG'  => 2,
		  'THIS' => 3,
		  'THAT' => 4,

		  'R0' => 0,
		  'R1' => 1,
		  'R2' => 2,
		  'R3' => 3,
		  'R4' => 4,
		  'R5' => 5,
		  'R6' => 6,
		  'R7' => 7,
		  'R8' => 8,
		  'R9' => 9,
		  'R10' => 10,
		  'R11' => 11,
		  'R12' => 12,
		  'R13' => 13,
		  'R14' => 14,
		  'R15' => 15,

		  'SCREEN' => 24575,
		  'KBD'    => 24576
		}

		@currentSymbol = 16
	end

	def addEntry(symbol)
		#if @symbolsTable(symbol)
		#if @symbolsTable.contains(symbol)
		if @symbolsTable[symbol]
			@symbolsTable[symbol]
		else
			@symbolsTable[symbol] = @currentSymbol
			@currentSymbol += 1
			@symbolsTable[symbol]
		end
	end

	# adds (symbol, address) pair to table
	#def addEntry(symbol, address)
		#return @symbols[symbol]
	#	symbolsTable[symbol] = address
	#end

	# returns the address integer associated with symbol
	def getAddress(symbol)
		@symbolsTable.fetch(symbol)
	end
end
