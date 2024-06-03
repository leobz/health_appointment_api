module Api::V1::Doctors
  class WorkingHoursController < ApplicationController
    def index
      @working_hours = WorkingHour.where(doctor_id: params[:doctor_id])

      render json: WorkingHourBlueprint.render(@working_hours)
    end
  end
end