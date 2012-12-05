require 'csv'

file1 = ARGV[0]
file2 = ARGV[1]

list1 = CSV.read(file1).flatten
list2 = CSV.read(file2).flatten

puts "List Comparatinator Initialized"

#ad-hoc column modification examples :
list1.map! {|hash| hash.gsub(/^.*\//,"")}
list1.map! {|hash| hash.gsub(".txt","")}

missing_1 = list1 - list2
missing_2 = list2 - list1

count1 = missing_1.count
count2 = missing_2.count

puts "Delta between 1 & 2 : " + count1.to_s() + " \n"
puts missing_1
puts "Delta between 2 & 1 : " + count2.to_s() + "\n"
puts missing_2