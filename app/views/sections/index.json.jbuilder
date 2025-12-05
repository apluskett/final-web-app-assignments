json.array! @sections do |section|
  json.extract! section, :id, :name
  json.course do
    json.extract! section.course, :id, :number, :title
    json.prefix do
      json.extract! section.course.prefix, :id, :code
    end
  end
  json.url section_url(section, format: :json)
end
