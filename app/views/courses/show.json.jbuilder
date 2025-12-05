json.extract! @course, :id, :number, :title, :credit_hours, :created_at, :updated_at
json.prefix do
  json.extract! @course.prefix, :id, :code, :description
end
json.sections @course.sections do |section|
  json.extract! section, :id, :name
end
