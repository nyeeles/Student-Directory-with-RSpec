require 'directory.rb'

describe 'Creating students' do
	it "turns Nic's details into a hash" do
		output = {name: "Nic", cohort: :May, year: 2014}
		expect(student("Nic", :May, 2014)).to eq output
	end
	
	it "turns Jamie's details into a hash" do
		output = {name: "Jamie", cohort: :May, year: 2014}
		expect(student("Jamie", :May, 2014)).to eq output
	end
	
	it "adds a created student to an array of students" do
		nic = student("Nic", :May, 2014)
		add(nic)
		expect(student_data.include? nic).to be_true
	end
end

describe 'Loading students from file' do
	
	it "knows that a file exists" do
		expect(CSV).to receive(:foreach).with('students.csv')
		load_students_from('students.csv')
	end
	
	it "loads students from file into student data" do
		load_students_from('students.csv')
		expect(student_data.length).to eq 1
	end
	
	it "loads students from file into the right format" do
		bob = {name: "Bob", cohort: :May, year: 2014}
		load_students_from('students.csv')		
		expect(student_data).to eq [bob]
	end
end

describe 'Saving students to a file' do

	it 'can open a file' do 
		expect(CSV).to receive(:open).with('students.csv', "w")
		save_students_to('students.csv')
	end

	it 'saves one student to file' do
		# create a fictional student 
		# save student to the file
		# clear student data
		# load student from file
		# check to see student data has the fictional student
		bob = student("Bob")
		add bob
		save_students_to('students.csv')
		student_data.clear
		load_students_from('students.csv')
		expect(student_data.include? bob).to be_true
	end
end

describe 'Input' do
	it "receives an input from the user" do
		expect(STDIN).to receive(:gets).and_return("")
		get_name
	end

	it "removes the new line character from the input" do
		expect(STDIN).to receive(:gets).and_return("Bob\n")
		expect(get_name).to eq 'Bob'
	end

	it "adds a student to student data by name" do
		jamie = {name: "Jamie", cohort: :May, year: 2014}
		type_entries_by("Jamie")
		expect(student_data.include? jamie).to be_true
	end

	it "stops inputting when user hits enter twice" do
		# as it stands, if you enter nothing, it will add a student, with name ""
		# we want it so that when nothing is entered, it stops inputting students
		type_entries_by("")
		expect(student_data.empty?).to be_true
	end

	it 'tally of students after user enters 1 name' do
		add student "Nic"
		expect(STDOUT).to receive(:puts).with "Now we have 1 student"
		student_tally_message
	end
	
	it 'tally of students after user enters 2 names' do
		add student "Nic"
		add student "Jamie"
		expect(STDOUT).to receive(:puts).with "Now we have 2 students"
		student_tally_message
	end

	it 'instruction to user on what to do' do
		expect(STDOUT).to receive(:puts).with "Please enter the names of students\nTo finish, just hit return twice"
		instructions_to_user
	end
end

describe 'Displaying students' do

		it 'shows that Nic in the database' do
			add student "nic"
			expect(STDOUT).to receive(:puts).with "nic (May cohort 2014)"
			print_students_list
		end

		it 'shows that Jamie is also in the database' do
			add student "nic"
			add student "jamie"
			output1 = "nic (May cohort 2014)"
			output2 = "jamie (May cohort 2014)"
			expect(STDOUT).to receive(:puts).with(output1)
			expect(STDOUT).to receive(:puts).with(output2)
			print_students_list
		end

		it 'print header' do
			expect(STDOUT).to receive(:puts).with "The students at Makers Academy are:"
			print_header
		end

		it 'print footer when we have only one student' do
			add student "Nic"
			expect(STDOUT).to receive(:puts).with "Overall, we have 1 great student"
			print_footer
		end

		it 'print footer when we have two students' do
			add student "Nic"
			add student "Jamie"
			expect(STDOUT).to receive(:puts).with "Overall, we have 2 great students"
			print_footer
		end
end

describe 'Interactive menu' do

	it 'displays the menu' do
		line1 = "1. Input the students"
		line2 = "2. Show the students"
		line3 = "3. Save the list to students.csv"
		line4 = "4. Load the list from students.csv"
		line5 = "9. Exit"
		output = "#{line1}\n#{line2}\n#{line3}\n#{line4}\n#{line5}"
		expect(STDOUT).to receive(:puts).with output
		print_menu
	end

	it 'takes users menu selection' do
		expect(STDIN).to receive(:gets).and_return("")
		menu_selection
	end

	it "removes the new line character from the input" do
		expect(STDIN).to receive(:gets).and_return("Bob\n")
		expect(menu_selection).to eq 'Bob'
	end

	context 'acts on users menu selection' do

		it 'when you press 1, it allows you to input students' do
			expect(self).to receive(:input_students)
			menu_options("1")
	end
		it 'when you press 2, it allows you to show the students' do
			expect(self).to receive(:show_students)
			menu_options("2")
	end
		it 'when you press 3, it allows you to save the students' do
			expect(self).to receive(:save_students_to)
			menu_options("3")
	end
		it 'when you press 4, it allows you to load the students' do
			expect(self).to receive(:load_students_from)
			menu_options("4")
	end
		it 'when you press 9, it allows you to exit the menu' do
			expect(self).to receive(:exit)
			menu_options("9")
	end

	end
end

