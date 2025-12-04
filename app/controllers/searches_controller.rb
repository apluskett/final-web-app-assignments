class SearchesController < ApplicationController
  # GET /search?q=term
  def index
    q = params[:q].to_s.strip

    @courses = Course.joins(:prefix).where(
      "prefixes.code ILIKE ? OR prefixes.description ILIKE ? OR courses.number ILIKE ? OR courses.title ILIKE ?", 
      "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%"
    ).includes(:prefix).limit(50)
    @sections = Section.joins(course: :prefix).where(
      "sections.name ILIKE ? OR prefixes.code ILIKE ? OR courses.number ILIKE ?", 
      "%#{q}%", "%#{q}%", "%#{q}%"
    ).includes(course: :prefix).limit(50)
    @students = Student.where("first_name ILIKE ? OR last_name ILIKE ? OR student_id ILIKE ? OR email ILIKE ?", 
      "%#{q}%", "%#{q}%", "%#{q}%", "%#{q}%").limit(50)
    @prefixes = Prefix.where("code ILIKE ? OR description ILIKE ?", "%#{q}%", "%#{q}%").limit(50)

    respond_to do |format|
      format.html
      format.json do
        render json: {
          courses: @courses.as_json(include: :prefix, methods: :display_name),
          sections: @sections.as_json(include: { course: :prefix }),
          students: @students.as_json(only: %i[id first_name last_name student_id email], methods: :full_name),
          prefixes: @prefixes.as_json(only: %i[id code description], methods: :display_name)
        }
      end
    end
  end
end
