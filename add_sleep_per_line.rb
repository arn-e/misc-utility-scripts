# add sleep command after certain number of lines

myFileName = ARGV[0]
line_num = 0
file = File.open(myFileName, "r")

file.each do |line|
	line_num +=1
	puts line
	if (line_num == 1)
		puts "sleep 2"
	end
	if (line_num % 100 == 0)
		puts "sleep 30 \n"
	end
end
