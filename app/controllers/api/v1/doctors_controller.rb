module Api::V1
  class DoctorsController < ApplicationController
    before_action :set_doctor, only: %i[ show update destroy ]

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # GET /doctors
    def index
      @doctors = Doctor.all

      render json: @doctors
    end

    # GET /doctors/1
    def show
      render json: @doctor
    end

    # POST /doctors
    def create
      @doctor = Doctor.new(doctor_params)

      if @doctor.save
        render json: @doctor, status: :created, location: api_v1_doctor_url(@doctor)
      else
        render json: @doctor.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /doctors/1
    def update
      if @doctor.update(doctor_params)
        render json: @doctor
      else
        render json: @doctor.errors, status: :unprocessable_entity
      end
    end

    # DELETE /doctors/1
    def destroy
      @doctor.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def doctor_params
      params.permit(:first_name, :last_name, :time_slot_per_client_in_min)
    end

    # Handle record not found
    def record_not_found
      render json: { error: "Couldn't find Doctor" }, status: :not_found
    end
  end
end
