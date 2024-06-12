module Api::V1::Doctors
  class AppointmentsController < ApplicationController
    before_action :set_doctor

    # GET /api/v1/doctors/:doctor_id/appointments
    def index
      @appointments = @doctor.appointments
      render json: @appointments
    end

    private

    def set_doctor
      @doctor = Doctor.find(params[:doctor_id])
    end
  end
end
