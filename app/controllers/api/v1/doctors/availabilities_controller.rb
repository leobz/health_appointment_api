module Api::V1::Doctors
  class AvailabilitiesController < ApplicationController
    def index
      doctor = Doctor.find(params[:doctor_id])
      start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
      end_date = params[:end_date] ? Date.parse(params[:end_date]) : start_date + 7.days

      availabilities = doctor.get_availabilities(start_date, end_date)

      render json: AvailabilityBlueprint.render(availabilities)
    end
  end
end
