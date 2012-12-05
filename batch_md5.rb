#requires an input CSV with at least 1 column representing the docid
#header should be DOCID (case insentitive)

require 'csv'
require 'digest/md5'

class GetMD5Hash

	def initialize
		puts "MD5 generator initialized"
		filename = "get_hash.txt" #todo : add file chooser
		@file = CSV.open(filename, {:headers => true, :header_converters => :symbol})
	end

	def getHashVal
		output_filename = "go_hash.txt"
		output = File.new(output_filename, "w")
		@file.each do |line|
			if @file.lineno == 2
				output << line.headers #weird, I wonder why it's outputting it in raw symbol format
				output << ",MD5" + "\n"
			end
			digest = Digest::MD5.hexdigest(line[:docid])
			output.write(line[:docid] + "," + digest + "\n")
		end
	end

end

goHash = GetMD5Hash.new
goHash.getHashVal
