class OfficeManagersController < ApplicationController
  before_action :set_office_manager, only: %i[ show edit update destroy ]

  # GET /office_managers or /office_managers.json
  def index
    @office_managers = OfficeManager.all
  end

  # GET /office_managers/1 or /office_managers/1.json
  def show
  end

  # GET /office_managers/new
  def new
    @office_manager = OfficeManager.new
  end

  # GET /office_managers/1/edit
  def edit
  end

  # POST /office_managers or /office_managers.json
  def create
    @office_manager = OfficeManager.new(office_manager_params)

    respond_to do |format|
      if @office_manager.save
        # assign selected employees to this manager
        if params[:office_manager] && params[:office_manager][:employee_ids]
          ids = params[:office_manager][:employee_ids].reject(&:blank?).map(&:to_i)
          Employee.where(id: ids).update_all(office_manager_id: @office_manager.id)
        end
        format.html { redirect_to @office_manager, notice: "Office manager was successfully created." }
        format.json { render :show, status: :created, location: @office_manager }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @office_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /office_managers/1 or /office_managers/1.json
  def update
    respond_to do |format|
      if @office_manager.update(office_manager_params)
        # reassign selected employees to this manager
        if params[:office_manager] && params[:office_manager][:employee_ids]
          ids = params[:office_manager][:employee_ids].reject(&:blank?).map(&:to_i)
          # clear previous assignments for employees not in ids
          Employee.where(office_manager_id: @office_manager.id).where.not(id: ids).update_all(office_manager_id: nil)
          # assign selected employees
          Employee.where(id: ids).update_all(office_manager_id: @office_manager.id)
        end
        format.html { redirect_to @office_manager, notice: "Office manager was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @office_manager }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @office_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /office_managers/1 or /office_managers/1.json
  def destroy
    @office_manager.destroy!

    respond_to do |format|
      format.html { redirect_to office_managers_path, notice: "Office manager was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_office_manager
      @office_manager = OfficeManager.find(params.require(:id))
    end

    # Only allow a list of trusted parameters through.
    def office_manager_params
      params.require(:office_manager).permit(:name, employee_ids: [])
    end
end
