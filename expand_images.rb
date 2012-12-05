#expanding images in Ruby
require 'csv'
require 'digest/md5'

class ExpandImages

	def initialize
		puts "Image Splitter Initialized"
		@@my_tempdir = "temp_expanded_images"
	end

	def read_file
		file = ARGV[0]
		puts "Reading File : #{file}\n"
		file_list = CSV.read(file).flatten
		puts "Cleaning File : #{file}\n"
		clean_file(file_list)
		iterate_list(file_list)
	end

	def clean_file(list)
		list.map! {|hash| hash.gsub(/^.*\//,"")}
		return list
	end

	def iterate_list(list)
		puts "Iterating Through List"
		list.each do |image|
			stripped_image = image.gsub(/\..*$/,"")
			image_digest = Digest::MD5.hexdigest(stripped_image)
			expand_images(image,image_digest,stripped_image)
		end
	end

	def expand_images(image,image_digest,stripped_image)
		puts "Expanding Image : #{image}"
		puts %x"mkdir #{@@my_tempdir}"
		command = %x"convert #{image} #{@@my_tempdir}/#{image_digest}-image-#{stripped_image}.%05d.tif"
		puts command
	end

end

go_expand = ExpandImages.new
go_expand.read_file()
