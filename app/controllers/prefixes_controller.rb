class PrefixesController < ApplicationController
  before_action :set_prefix, only: [:show, :edit, :update, :destroy]

  def index
    @prefixes = Prefix.all
  end

  def show
  end

  def new
    @prefix = Prefix.new
  end

  def edit
  end

  def create
    @prefix = Prefix.new(prefix_params)

    respond_to do |format|
      if @prefix.save
        format.html { redirect_to prefixes_path, notice: 'Prefix was successfully created.' }
        format.json { render :show, status: :created, location: @prefix }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prefix.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @prefix.update(prefix_params)
        format.html { redirect_to prefixes_path, notice: 'Prefix was successfully updated.' }
        format.json { render :show, status: :ok, location: @prefix }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prefix.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    begin
      @prefix.destroy!
      respond_to do |format|
        format.html { redirect_to prefixes_url, notice: 'Prefix was successfully deleted.' }
        format.json { head :no_content }
      end
    rescue ActiveRecord::RecordNotDestroyed => e
      respond_to do |format|
        format.html { redirect_to prefixes_url, alert: 'Cannot delete prefix because it has associated courses.' }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_prefix
    @prefix = Prefix.find(params[:id])
  end

  def prefix_params
    params.require(:prefix).permit(:code, :description)
  end
end