require 'csv'
require 'fileutils'

# Define the number of records to generate
num_staff = 20
num_students = 10
num_classes = 2
num_buildings = 1
num_students_per_class = 3
num_staff_per_class = 2

# Create the 'artifact' folder if it doesn't exist
FileUtils.mkdir_p('artifact')


def generate_random_string(length)
    chars = ('a'..'z').to_a + ('A'..'Z').to_a
    random_string = (0...length).map { chars[rand(chars.length)] }.join
  
    # Add a unique date number to the random string
    date_number = Time.now.strftime("%Y%m%d%H%M%S%L")  # Format: YearMonthDayHourMinuteSecondMillisecond
    unique_string = "#{random_string}_#{date_number}"
  
    unique_string
  end

def generate_unique_email(domain, existing_emails)
  email = "automation.testing+#{generate_random_string(10)}@#{domain}"
  while existing_emails.include?(email)
    email = "automation.testing+#{generate_random_string(10)}@#{domain}"
  end
  email
end


def generate_staff_data(num_staff, domain)
    staff_emails = []
    staff_ids = []
  
    CSV.open('artifact/staff.csv', 'w') do |csv|  # Specify the path inside the 'artifact' folder
      csv << ['staff_email', 'staff_id', 'staff_first_name', 'staff_last_name']
  
      num_staff.times do |i|
        staff_email = generate_unique_email(domain, staff_emails)
        staff_id =  "staff#{i+1}"
        staff_first_name = "John#{i+1}"
        staff_last_name = "Doe#{i+1}"
  
        csv << [staff_email, staff_id, staff_first_name, staff_last_name]
  
        staff_emails << staff_email
        staff_ids << staff_id
      end
    end
  end

def generate_student_data(num_students, domain)
  student_emails = []
  student_ids = []

  CSV.open('artifact/students.csv', 'w') do |csv|
    csv << ['student_email', 'student_id', 'student_first_name', 'student_last_name']

    num_students.times do |i|
      student_email = generate_unique_email(domain, student_emails)
      student_id = "student#{i+1}"
      student_first_name = "Jane#{i+1}"
      student_last_name = "Smith#{i+1}"

      csv << [student_email, student_id, student_first_name, student_last_name]

      student_emails << student_email
      student_ids << student_id
    end
  end
end

def generate_classes_data(num_classes,num_buildings)
    CSV.open('artifact/classes.csv', 'w') do |csv|
      csv << ['class_id', 'class_name', 'Description', 'building_id']
  
      num_classes.times do |i|
        class_id = "ClassID#{i+1}"
        class_name = "Class#{i+1}"
        description = "This is class #{i}"
        building_id = 1000 + (i % num_buildings)
  
        csv << [class_id, class_name, description, building_id]
      end
    end
  end

def generate_enrollment_data(num_classes, num_students_per_class, num_staff_per_class)
    CSV.open('artifact/enrollment.csv', 'w') do |csv|
      csv << ['class_id', 'student_id', 'staff_id']
  
      num_classes.times do |i|
        class_id = "ClassID#{i+1}"
  
        num_students_per_class.times do |j|
          student_id = "student#{i*num_students_per_class + j + 1}"
  
          if j < num_staff_per_class
            staff_id = "staff#{i*num_staff_per_class + j + 1}"
          else
            staff_id = nil
          end
  
          csv << [class_id, student_id, staff_id]
        end
      end
    end
  end


generate_staff_data(num_staff, 'apptegy.com')
generate_student_data(num_students, 'apptegy.com')
generate_classes_data(num_classes, num_buildings)
generate_enrollment_data(num_classes, num_students_per_class, num_staff_per_class)
