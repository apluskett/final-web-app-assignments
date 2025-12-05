class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy]

  def index
    @sections = Section.includes(:course => :prefix).all
    
    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @available_students = Student.where.not(id: @section.student_ids)
    
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @section = Section.new
    @courses = Course.includes(:prefix).all
    @students = Student.all
  end

  def edit
    @courses = Course.includes(:prefix).all
    @students = Student.all
    @available_students = Student.where.not(id: @section.student_ids)
  end

  def create
    @section = Section.new(section_params)
    @courses = Course.includes(:prefix).all
    @students = Student.all

    respond_to do |format|
      if @section.save
        # Handle student assignments
        if params[:section][:student_ids].present?
          student_ids = params[:section][:student_ids].reject(&:blank?)
          @section.student_ids = student_ids
        end
        
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @courses = Course.includes(:prefix).all
    @students = Student.all
    @available_students = Student.where.not(id: @section.student_ids)
    # Ensure course association is loaded for edit view
    @section.course.reload if @section.course
    
    respond_to do |format|
      if @section.update(section_params)
        # Handle student assignments
        if params[:section][:student_ids].present?
          student_ids = params[:section][:student_ids].reject(&:blank?)
          @section.student_ids = student_ids
        else
          @section.students.clear
        end
        
        format.html { redirect_to @section, notice: 'Section was successfully updated.' }
        format.json { render :show, status: :ok, location: @section }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Section was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:course_id, :name)
  end
end