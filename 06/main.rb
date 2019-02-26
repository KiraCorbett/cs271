load 'parser.rb'
load 'code.rb'
load 'symbol_table.rb'

parser = Parser.new(ARGV[0])

parser.parse()
