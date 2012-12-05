require 'csv'
require 'digest/md5'

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
		#remove BOM
		file = File.open("#{input}", "r") 
		clean_output = 'bom_removed.dat'
 		clean_outfile = File.new(clean_output, "w")
  		content = file.read.force_encoding("UTF-8")
  		content.gsub!("\xEF\xBB\xBF".force_encoding("UTF-8"), '')
  		clean_outfile.write(content)
 		file.close

 		input = clean_output
 		puts "New input : #{input}"
		@file = CSV.open(input, :encoding => 'utf-8', :quote_char => quote, :col_sep => sep, :row_sep => :auto, :headers => true, :return_headers => true, :write_headers => true)
		
	end

	def createScript(column)
		output_file = 'update_' + column.to_s() + '.sql'
		output = File.new(output_file, "w")
		puts @file.eof?
		@file.rewind
		puts @file.lineno
		@file.each do |line|
			value = line["#{column}"]
			docid = line["docid"]
			docid_digest = Digest::MD5.hexdigest(docid)
			column_name = column
			query_string = 
			"update TABLE set value = \"" + value.to_s() + \
			"\" where doc_id = \"" + docid_digest.to_s() + \
			"\" and name = \"" + column_name.to_s() + "\";"
			if @file.lineno >1
				output.write("#{query_string}\n")
			end

		end
 	end	

end

goCSV = ReadCSV.new
goCSV.createScript("CSV_COL_1")
goCSV.createScript("CSV_COL_2")
goCSV.createScript("CSV_COL_3")
goCSV.createScript("CSV_COL_4")
goCSV.createScript("CSV_COL_5")
goCSV.createScript("CSV_COL_6")
goCSV.createScript("CSV_COL_7")