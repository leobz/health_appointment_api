module Api::V1
  class AppointmentsController < ApplicationController
    before_action :set_appointment, only: %i[ update ]

    def create
      @appointment = Appointment.new(appointment_params)

      if @appointment.save
        render json: AppointmentBlueprint.render(@appointment), status: :created, location: api_v1_appointments_path(@appointment)
      else
        render json: @appointment.errors, status: :unprocessable_entity
      end
    end

    def update
      if @appointment.update(appointment_params)
        render json: AppointmentBlueprint.render(@appointment), location: api_v1_appointments_path(@appointment)
      else
        render json: @appointment.errors, status: :unprocessable_entity
      end
    end

    private

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params
        .permit(
          [
            :doctor_id,
            :patient_id,
            :start_time
          ]
        )
    end
  end
end
