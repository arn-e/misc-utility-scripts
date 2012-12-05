# get columns from CSV file
require "csv"

class ReadCSV
	
	def initialize
		quote = "\u00fe"
		sep = "\u0014"
		puts "CSV reader initialized"
		if ARGV.length != 1
 	 		puts "csv_read.rb -- reads CSV or delimited file and returns individual columns"
  			puts "Usage: dat_to_db_import.rb [dat file]"
  			exit 1
		end
		input = ARGV[0]
		@file = CSV.open(input, :encoding => 'utf-8', :quote_char => quote, :col_sep => sep, :row_sep => :auto, :headers => true, :header_converters => :symbol)

	end

	def writeCSV
		output_csv = 'output_csv_results.csv'
		output = File.new(output_csv, "w")
		@file.each do |line|
			if @file.lineno == 2
				output << ['docid', 'parentid', 'xref_beg_doc', 'xref_end_doc'].to_csv
			end
			output.write([line[:docid],line[:parentid],line[:xref_beg_doc], line[:xref_end_doc]].to_csv)
		end
	end
	
end

goCSV = ReadCSV.new
goCSV.writeCSV