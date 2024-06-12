module Api::V1::Doctors
  class WorkingHoursController < ApplicationController
    before_action :set_working_hour, only: %i[ show update destroy ]

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def index
      @working_hours = WorkingHour.where(doctor_id: params[:doctor_id])

      render json: WorkingHourBlueprint.render(@working_hours)
    end

    # POST /working_hours
    def create
      @working_hour = WorkingHour.new(working_hour_params)

      if @working_hour.save
        render json: @working_hour, status: :created, location: api_v1_doctor_working_hours_path(@working_hour)
      else
        render json: @working_hour.errors, status: :unprocessable_entity
      end
    end

    # GET /working_hours/1
    def show
      render json: @working_hour
    end

    # PATCH/PUT /working_hours/1
    def update
      if @working_hour.update(working_hour_params)
        render json: @working_hour
      else
        render json: @working_hour.errors, status: :unprocessable_entity
      end
    end

    # DELETE /working_hours/1
    def destroy
      @working_hour.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_working_hour
      @working_hour = WorkingHour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def working_hour_params
      params.permit(:day_of_week, :start_time, :end_time, :doctor_id)
    end

    # Handle record not found
    def record_not_found
      render json: { error: "Couldn't find WorkingHour" }, status: :not_found
    end
  end
end