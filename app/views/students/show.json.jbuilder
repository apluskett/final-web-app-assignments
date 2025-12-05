json.extract! @student, :id, :first_name, :last_name, :student_id, :email, :name, :created_at, :updated_at
json.sections @student.sections do |section|
  json.extract! section, :id, :name
  json.course do
    json.extract! section.course, :id, :title, :number, :credit_hours
    json.prefix do
      json.extract! section.course.prefix, :id, :code, :description
    end
  end
end
