class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def index
    @students = Student.includes(:sections => {:course => :prefix}).all
  end

  def show
    @available_sections = Section.includes(:course => :prefix).where.not(id: @student.section_ids)
  end

  def new
    @student = Student.new
    @sections = Section.includes(:course => :prefix).all
  end

  def edit
    @sections = Section.includes(:course => :prefix).all
    @available_sections = Section.includes(:course => :prefix).where.not(id: @student.section_ids)
  end

  def create
    @student = Student.new(student_params)
    @sections = Section.includes(:course => :prefix).all

    respond_to do |format|
      if @student.save
        # Handle section assignments
        if params[:student][:section_ids].present?
          section_ids = params[:student][:section_ids].reject(&:blank?)
          @student.section_ids = section_ids
        end
        
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @sections = Section.includes(:course => :prefix).all
    @available_sections = Section.includes(:course => :prefix).where.not(id: @student.section_ids)
    
    respond_to do |format|
      if @student.update(student_params)
        # Handle section assignments
        if params[:student][:section_ids].present?
          section_ids = params[:student][:section_ids].reject(&:blank?)
          @student.section_ids = section_ids
        else
          @student.sections.clear
        end
        
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :student_id, :first_name, :last_name, :email)
  end
end