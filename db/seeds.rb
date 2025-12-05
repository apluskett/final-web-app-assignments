# Clear existing data
Student.destroy_all
Section.destroy_all
Course.destroy_all
Prefix.destroy_all

# Create prefixes
cs_prefix = Prefix.create!(code: "CS", description: "Computer Science")
math_prefix = Prefix.create!(code: "MATH", description: "Mathematics")
phys_prefix = Prefix.create!(code: "PHYS", description: "Physics")

# Create courses
cs3710 = Course.create!(
  prefix: cs_prefix,
  number: "3710",
  title: "Advanced Software Engineering",
  credit_hours: 3,
  syllabus: "<h2>CS 3710 - Advanced Software Engineering</h2><p>This course covers advanced topics in software engineering including design patterns, testing, and project management.</p><ul><li>Design patterns and architecture</li><li>Test-driven development</li><li>Version control and CI/CD</li></ul>"
)

math2410 = Course.create!(
  prefix: math_prefix,
  number: "2410",
  title: "Statistics",
  credit_hours: 3,
  syllabus: "<h2>MATH 2410 - Statistics</h2><p>Introduction to statistical methods and probability theory.</p>"
)

phys2311 = Course.create!(
  prefix: phys_prefix,
  number: "2311",
  title: "General Physics I",
  credit_hours: 4,
  syllabus: "<h2>PHYS 2311 - General Physics I</h2><p>Classical mechanics, thermodynamics, and wave motion.</p>"
)

# Create sections
cs_section_001 = Section.create!(course: cs3710, name: "001")
cs_section_002 = Section.create!(course: cs3710, name: "002")
math_section_001 = Section.create!(course: math2410, name: "001")
phys_section_001 = Section.create!(course: phys2311, name: "001")

# Create students
students = [
  Student.create!(first_name: "Alexander", last_name: "Pluskett", student_id: "S001001", email: "alexander.pluskett@university.edu"),
  Student.create!(first_name: "Jane", last_name: "Smith", student_id: "S001002", email: "jane.smith@university.edu"),
  Student.create!(first_name: "Bob", last_name: "Johnson", student_id: "S001003", email: "bob.johnson@university.edu"),
  Student.create!(first_name: "Alice", last_name: "Brown", student_id: "S001004", email: "alice.brown@university.edu"),
  Student.create!(first_name: "Charlie", last_name: "Davis", student_id: "S001005", email: "charlie.davis@university.edu")
]

# Enroll students in sections
cs_section_001.students << [students[0], students[1], students[2]]
cs_section_002.students << [students[3], students[4]]
math_section_001.students << [students[0], students[2], students[4]]
phys_section_001.students << [students[1], students[3]]
