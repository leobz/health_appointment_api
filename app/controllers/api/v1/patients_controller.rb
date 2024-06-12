module Api::V1
  class PatientsController < ApplicationController
    before_action :set_patient, only: %i[ show update destroy ]

    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    # GET /patients
    def index
      @patients = Patient.all

      render json: @patients
    end

    # GET /patients/1
    def show
      render json: @patient
    end

    # POST /patients
    def create
      @patient = Patient.new(patient_params)

      if @patient.save
        render json: @patient, status: :created, location: api_v1_patient_url(@patient)
      else
        render json: @patient.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /patients/1
    def update
      if @patient.update(patient_params)
        render json: @patient
      else
        render json: @patient.errors, status: :unprocessable_entity
      end
    end

    # DELETE /patients/1
    def destroy
      @patient.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def patient_params
      params.permit(:first_name, :last_name, :time_slot_per_client_in_min)
    end

    # Handle record not found
    def record_not_found
      render json: { error: "Couldn't find Patient" }, status: :not_found
    end
  end
end
