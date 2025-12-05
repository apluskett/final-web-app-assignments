json.array! @courses do |course|
  json.extract! course, :id, :number, :title, :credit_hours
  json.prefix do
    json.extract! course.prefix, :id, :code, :description
  end
  json.url course_url(course, format: :json)
end
