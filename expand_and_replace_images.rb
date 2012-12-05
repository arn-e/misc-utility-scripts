require 'mysql'
require 'csv'
require 'digest/md5'

class ExpandImages

	def initialize
		puts "Image Splitter Initialized"
		#initialize class variables
		@@my_client = 'xxx'
		@@my_matter = 'xxxr'
		@@my_database = "xxx_#{@@my_client}_#{@@my_matter}"
		@@my_host = 'xxx'
		@@my_user = 'xxx'
		@@my_tempdir = "xxx"
		@@my_backup_dir = 'xxx'
	end

	def workflow
		read_file()
		remove_file_path(@@file_list)
		iterate_list(@@file_list)
		remove_file_extension(@@file_list)
		connect_to_database()
		query_database(@@file_list)
		backup(@@file_list)
		copy_expanded_images(@@file_list)
	end

	def read_file
		file = ARGV[0]
		puts "Reading File : #{file}\n"
		@@file_list = CSV.read(file).flatten
		puts "Cleaning File : #{file}\n"
	end

	def remove_file_path(list)
		list.map! {|hash| hash.gsub(/^.*\//,"")}
		return list
	end

	def remove_file_extension(list)
		list.map! {|hash| hash.gsub(/\..*$/,"")}
		return list
	end

	def iterate_list(list)
		puts "Iterating Through List"
		list.each do |image|
			#remove file extension
			stripped_image = image.gsub(/\..*$/,"")
			image_digest = Digest::MD5.hexdigest(stripped_image)
			expand_images(image,image_digest,sripped_image)
		end
	end

	def expand_images(image,image_digest,stripped_image)
		puts "Expanding Image : #{image}"
		puts %x"mkdir #{@@my_tempdir}"
		command = %x"convert #{image} #{@@my_tempdir}/#{image_digest}-image-#{stripped_image}.%05d.tif"
		puts command
	end

	def test_db_connection
		puts "Testing Database Connection"
		db = Mysql.new("#{@@my_host}","#{@@my_user}",'',"#{@@my_database}")
		puts "Test Completed"
	end

	def connect_to_database
		puts "Connecting to DB"
		@@dbh = Mysql.real_connect("#{@@my_host}","#{@@my_user}",'',"#{@@my_database}")
		puts "Connection Established"
	end

	def query_database(list)
		puts "Gathering Path Information"
		@@file_paths = Hash.new
		list.each do |document|
			image_digest = Digest::MD5.hexdigest(document)
			res = @@dbh.query("select concat('/data/appdata/#{@@my_client}/#{@@my_matter}/blobs/', load_name, '/', part, '/', substr(doc_id,1,2), '/', substr(doc_id,3,2), '/', substr(doc_id,5,2), '/') from doc_denorm where doc_id = '#{image_digest}'")
			res.each do |row|
				@@file_paths[image_digest] = row[0]
				#puts "Debug : Document ID : #{image_digest}, File Path : #{@@file_paths[image_digest]}"
			end
			puts "Number of rows returned: #{res.num_rows}"
		end
		@@dbh.close if @@dbh
		puts "DB Connection Closed"
	end

	def backup(list)
		list.each do |document|
			image_digest = Digest::MD5.hexdigest(document)
			path = @@file_paths[image_digest]
			abs_backup_dir = "#{path}#{@@my_backup_dir}"
			puts %x"mkdir #{abs_backup_dir}"
			puts %x"mv #{path}*-image-* #{abs_backup_dir}/"
			puts %x"mv #{path}*-export-* #{abs_backup_dir}/"
		end
	end

	def copy_expanded_images(list)
		list.each do |document|
			image_digest = Digest::MD5.hexdigest(document)
			path = @@file_paths[image_digest]
			puts %x"cp ./#{@@my_tempdir}/#{image_digest}* #{path}"
		end
	end
end

go_expand = ExpandImages.new
go_expand.workflow()