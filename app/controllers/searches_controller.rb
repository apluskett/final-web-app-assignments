class SearchesController < ApplicationController
  # GET /search?q=term
  def index
    q = params[:q].to_s.strip

    @employees = Employee.search(q).limit(50)
    @projects = Project.search(q).limit(50)
    @offices = Office.search(q).limit(50)
    @office_managers = OfficeManager.search(q).limit(50)

    respond_to do |format|
      format.html
      format.json do
        render json: {
          employees: @employees.as_json(only: %i[id name office_manager_id]),
          projects: @projects.as_json(only: %i[id project_name description]),
          offices: @offices.as_json(only: %i[id number employee_id]),
          office_managers: @office_managers.as_json(only: %i[id name])
        }
      end
    end
  end
end
