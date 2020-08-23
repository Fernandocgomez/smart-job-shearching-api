require "rails_helper"

RSpec.describe "JobPositions", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:user, username: "cristobalgomez", email: "cristobal@live.com") }

  let(:token) { get_auth_token(user.id) }
  let(:other_user_token) { get_auth_token(other_user.id) }

  let(:company) { create(:company, user_id: user.id) }

  let(:params) { get_job_position_params("valid", company.id) }
  let(:invalid_params) { get_job_position_params("invalid", company.id) }
  let(:update_params) { { "name" => "New name" } }
  let(:invalid_update_params) { { "name" => nil } }

  let(:job_position) { create(:job_position, company_id: company.id) }

  describe '#create' do

    context 'when request is succesful' do
      before(:each) do
        post "/api/job_positions", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 201 status' do
        expect(response).to have_http_status(201)
      end
      it 'returns an instance of the JobPosition model on JSON' do
        matcher = get_job_position_matcher(@resp_json["id"], company.id)

        expect(@resp_json).to match(matcher)
      end
      it 'saves the job position to the DB' do
        expect(JobPosition.count).to eq(1)
      end
    end

    context 'when request fails because of invalid params' do
      before(:each) do
        post "/api/job_positions", params: invalid_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 400 status' do
        expect(response).to have_http_status(400)
      end
      it 'returns an object of errors on JSON' do
        expect(@resp_json).to include("state")
        expect(@resp_json).to_not eq({})
      end
    end

    context 'when a user tries to create a job position not associated with one of its companies' do
      before(:each) do
        post "/api/job_positions", params: params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not create a job position that is not associated with one of yours companies without being an admin")
      end
    end

  end

  describe '#show' do

    context 'when request is succesful' do
      before(:each) do
        get "/api/job_position/#{job_position.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 200 status' do
        expect(response).to have_http_status(200)
      end
      it 'returns an instance of the JobPosition model on JSON based on the id provided' do
        matcher = get_job_position_matcher(@resp_json["id"], company.id)
        expect(@resp_json).to match(matcher)
      end
    end

    context 'when request fails because of an invalid id' do
      before(:each) do
        get "/api/job_position/#{job_position.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 404 status' do
        expect(response).to have_http_status(404)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to match("job position can't be found")
      end
    end
    
    context 'when user tries to access a job position not associated with its companies' do
      before(:each) do
        get "/api/job_position/#{job_position.id}", headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not access a job position that is not associated with one of yours companies without being an admin")
      end      
    end

  end

  describe '#update' do

    context 'when request is successful' do
      before(:each) do
        put "/api/job_position/#{job_position.id}", params: update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 200 status' do
        expect(response).to have_http_status(200)
      end
      it 'returns the updated instance of the JobPosition model on JSON" do' do
        matcher = get_job_position_matcher(@resp_json["id"], company.id)
        matcher["name"] = update_params["name"]
        expect(@resp_json).to match(matcher)
      end
    end

    context 'when request fails becuase of invalid params' do
      before(:each) do
        put "/api/job_position/#{job_position.id}", params: invalid_update_params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 400 status' do
        expect(response).to have_http_status(400)
      end
      it 'returns an obj of error on JSON' do
        expect(@resp_json).to_not eq({})
        expect(@resp_json).to include("name")
      end
    end

    context 'when request fails because of an invalid id' do
      before(:each) do
        put "/api/job_position/#{job_position.id + 1}", params: params, headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 404 status' do
        expect(response).to have_http_status(404)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to eq("job position can't be found")
      end
    end
    
    context 'when user tries to update a job position not associated with its companies' do
      before(:each) do
        put "/api/job_position/#{job_position.id}", params: params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not update a job position that is not associated with one of yours companies without being an admin")
      end      
    end

  end

  describe '#destroy' do

    context 'when request is succesful' do
      before(:each) do
        delete "/api/job_position/#{job_position.id}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 200 status' do
        expect(response).to have_http_status(200)
      end
      it 'returns a confirmatino message on JSON' do
        expect(@resp_json).to eq("job position has been deleted")
      end
    end

    context 'when request fails because an invalid id' do
      before(:each) do
        delete "/api/job_position/#{job_position.id + 1}", headers: token
        @resp_json = parse_resp_on_json(response)
      end
      it 'returns a 404 status' do
        expect(response).to have_http_status(404)
      end
      it 'returns an error message on JSON' do
        expect(@resp_json).to eq("job position can't be found")
      end
    end
    
    context 'when user tries to delete a job position not associated with its companies' do
      before(:each) do
        delete "/api/job_position/#{job_position.id}", params: params, headers: other_user_token
        @resp_json = parse_resp_on_json(response)
      end
      it "returns a 401 status" do
        expect(response).to have_http_status(401)
      end
      it "returns an error message on JSON" do
        expect(@resp_json).to match("you can not delete a job position that is not associated with one of yours companies without being an admin")
      end      
    end

  end

end