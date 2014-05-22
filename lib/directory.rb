require 'csv'

def student(name, cohort=:May, year=2014)
	{name: name, cohort: cohort, year: year}
end

def load_students_from(file)
	CSV.foreach(file) {|row| student_data << imports_students_from(row) } 
end

def student_data
	@students ||= []
end

def add(student)
	student_data << student
end

def imports_students_from(row)
	{name: row[0], cohort: row[1].to_sym, year: row[2].to_i}
end

def save_students_to(file)
	CSV.open(file, "w") do |csv| 
		student_data.each do |student|
			csv << export(student)
		end
	end
end

def export(student)
	student.values
end

def input_students
	#get the name
	#use name to add student to array
	#gets a name and assigns it to 'by_name'
	instructions_to_user
	type_entries_by get_name #calls 
end

def get_name
	STDIN.gets.chomp
end

def type_entries_by(name)
	while !name.empty? do
		add(student(name))
		student_tally_message
		name = get_name
	end
end

def print_students_list
	# 1. go through every item in the student data
	# 2. puts the name, month and year of each item
	student_data.each do |hash| 
		name = hash[:name]
		cohort = hash[:cohort]
		year = hash[:year]
	puts "#{name} (#{cohort} cohort #{year})"
	end
end

def show_students
	print_header
	print_students_list
	print_footer
end

def print_header
	puts "The students at Makers Academy are:"
end

def print_footer
	summary =  "Overall, we have #{student_count} great student"
	puts student_count > 1 ? summary+"s" : summary 
end

def student_tally_message
	summary = "Now we have #{student_count} student"
	puts student_count > 1 ? summary+"s" : summary
end

def student_count
	student_data.length
end

def instructions_to_user
	puts "Please enter the names of students\nTo finish, just hit return twice"
end

def print_menu
	line1 = "1. Input the students"
	line2 = "2. Show the students"
	line3 = "3. Save the list to students.csv"
	line4 = "4. Load the list from students.csv"
	line5 = "9. Exit"
	output = "#{line1}\n#{line2}\n#{line3}\n#{line4}\n#{line5}"
	puts output
end

def menu_selection
	STDIN.gets.chomp
end

def menu_options(menu_selection)
	case menu_selection
	when "1" then input_students
	when "2" then show_students
	when "3" then save_students_to('students.csv')
	when "4" then load_students_from('students.csv')
	when "9" then exit
	else puts "Not recognised"
	end
end

def interactive_menu
	load_students_from('students.csv')
	loop do
		print_menu
		menu_options menu_selection
	end
end

interactive_menu

