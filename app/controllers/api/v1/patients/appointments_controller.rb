module Api::V1::Patients
  class AppointmentsController < ApplicationController
    before_action :set_patient

    # GET /api/v1/patients/:patient_id/appointments
    def index
      @appointments = @patient.appointments
      render json: @appointments
    end

    private

    def set_patient
      @patient = Patient.find(params[:patient_id])
    end
  end
end
