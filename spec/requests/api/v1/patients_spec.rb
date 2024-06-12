require 'rails_helper'

RSpec.describe "Patients", type: :request do
  let!(:patients) { create_list(:patient, 10) }
  let(:patient_id) { patients.first.id }

  describe "Index" do
    it 'returns a list of patients' do
      get api_v1_patients_path

      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
  end

  describe "Show" do
    it 'returns the patient if record exists' do
      get api_v1_patient_path(patient_id)

      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json['id']).to eq(patient_id)
    end

    it 'returns status code 404 if record does not exist' do
      invalid_patient_id = 100
      get api_v1_patient_path(invalid_patient_id)

      expect(response).to have_http_status(404)
      expect(response.body).to match(/Couldn't find Patient/)
    end
  end

  describe "Create" do
    let(:valid_attributes) { { first_name: 'John', last_name: 'Doe' } }

    it 'Valid Request: creates a patient' do
      post api_v1_patients_path, params: valid_attributes

      expect(response).to have_http_status(201)
      expect(json['first_name']).to eq('John')
      expect(json['last_name']).to eq('Doe')
    end

    it 'Invalid Request: returns status code 422' do
      post api_v1_patients_path, params: { first_name: 'John' }

      expect(response).to have_http_status(422)
      expect(json['last_name']).to include("can't be blank")
    end
  end

  describe "Update" do
    let(:valid_attributes) { { first_name: 'Jane' } }

    it 'updates the record' do
      put api_v1_patient_path(patient_id), params: valid_attributes

      expect(json['first_name']).to eq('Jane')
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE" do
    it 'returns status code 204' do
      delete api_v1_patient_path(patient_id)

      expect(response).to have_http_status(204)
    end
  end
end

def json
  JSON.parse(response.body)
end