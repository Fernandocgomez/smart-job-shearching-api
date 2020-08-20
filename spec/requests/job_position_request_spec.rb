require "rails_helper"

RSpec.describe "JobPositions", type: :request do

  let(:user) { create(:user) }
  let(:other_user) { create(:user, username: "cristobalgomez", email: "cristobal@live.com") }

  let(:token) { get_auth_token(user.id) }
  let(:other_user_token) { get_auth_token(other_user.id) }

  let(:company) { create(:company, user_id: user.id) }
  let(:other_user_company) { create(:company, user_id: other_user.id) }

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

  # before(:each) do
  #   @user = create_user
  #   @company = create_company
  #   @params = get_job_position_params(@user.id, @company.id)
  #   @invalid_params = get_job_position_invalid_params(@user.id, @company.id, "TXX")
  # end
  # describe "POST /api/job_positions" do
  #   context "request is successful" do
  #     it "returns a 201 status" do
  #       post "/api/job_positions", params: @params

  #       expect(response).to have_http_status(201)
  #     end
  #     it "returns an instance of the JobPosition model on JSON" do
  #       post "/api/job_positions", params: @params
  #       resp_json = JSON.parse(response.body)
  #       matcher = get_job_position_matcher(@user.id, @company.id, resp_json["resp"]["id"])

  #       expect(resp_json["resp"]).to match(matcher)
  #     end
  #     it "saves the job_position on the DB" do
  #       db_size = JobPosition.all.size
  #       post "/api/job_positions", params: @params

  #       expect(JobPosition.all.size).to eq(db_size + 1)
  #     end
  #   end
  #   context "request fails" do
  #     it "returns a 400 status" do
  #       post "/api/job_positions", params: @invalid_params

  #       expect(response).to have_http_status(400)
  #     end
  #     it "returns an object of errors on JSON" do
  #       post "/api/job_positions", params: @invalid_params
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to include("state")
  #       expect(resp_json["resp"]).to_not eq({})
  #     end
  #   end
  # end
  # describe "GET /api/job_position/:id" do
  #   before(:each) do
  #     post "/api/job_positions", params: @params
  #     @job_position = JSON.parse(response.body)
  #   end
  #   context "request is successful" do
  #     it "returns a 200 status" do
  #       get "/api/job_position/#{@job_position["resp"]["id"]}"

  #       expect(response).to have_http_status(200)
  #     end
  #     it "returns an instance of the JobPosition model on JSON based on the id provided" do
  #       get "/api/job_position/#{@job_position["resp"]["id"]}"
  #       resp_json = JSON.parse(response.body)
  #       matcher = get_job_position_matcher(@user.id, @company.id, resp_json["resp"]["id"])

  #       expect(resp_json["resp"]).to match(matcher)
  #     end
  #   end
  #   context "request fails" do
  #     it "returns a 404 status" do
  #       get "/api/job_position/#{@job_position["resp"]["id"] + 1}"

  #       expect(response).to have_http_status(404)
  #     end
  #     it "returns an error message on JSON" do
  #       get "/api/job_position/#{@job_position["resp"]["id"] + 1}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eq("job position can't be found")
  #     end
  #   end
  # end
  # describe "PUT /api/job_position/:id" do
  #   before(:each) do
  #     post "/api/job_positions", params: @params
  #     @job_position = JSON.parse(response.body)
  #     @changes = { "name" => "New name" }
  #     @invalid_changes = { "name" => nil }
  #   end
  #   context "request is successful" do
  #     it "returns a 200 status" do
  #       put "/api/job_position/#{@job_position["resp"]["id"]}", params: @changes

  #       expect(response).to have_http_status(200)
  #     end
  #     it "returns the updated instance of the JobPosition model on JSON" do
  #       put "/api/job_position/#{@job_position["resp"]["id"]}", params: @changes
  #       resp_json = JSON.parse(response.body)
  #       matcher = get_job_position_matcher(@user.id, @company.id, resp_json["resp"]["id"])
  #       matcher["name"] = @changes["name"]

  #       expect(resp_json["resp"]).to match(matcher)
  #     end
  #   end
  #   context "request fails(invalid params)" do
  #     it "returns a 400 status" do
  #       put "/api/job_position/#{@job_position["resp"]["id"]}", params: @invalid_changes

  #       expect(response).to have_http_status(400)
  #     end
  #     it "returns an object of errors of JSON" do
  #       put "/api/job_position/#{@job_position["resp"]["id"]}", params: @invalid_changes
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to_not eq({})
  #       expect(resp_json["resp"]).to include("name")
  #     end
  #   end
  #   context "request fails(invalid id)" do
  #     it "returns a 404 status" do
  #       put "/api/job_position/#{@job_position["resp"]["id"] + 1}", params: @changes

  #       expect(response).to have_http_status(404)
  #     end
  #     it "returns an error message on JSON" do
  #       put "/api/job_position/#{@job_position["resp"]["id"] + 1}", params: @changes
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eq("job position can't be found")
  #     end
  #   end
  # end
  # describe "DELETE /api/job_position/:id" do
  #   before(:each) do
  #     post "/api/job_positions", params: @params
  #     @job_position = JSON.parse(response.body)
  #   end
  #   context "request is successful" do
  #     it "returns a 200 status" do
  #       delete "/api/job_position/#{@job_position["resp"]["id"]}"

  #       expect(response).to have_http_status(200)
  #     end
  #     it "returns a confirmatino message on JSON" do
  #       delete "/api/job_position/#{@job_position["resp"]["id"]}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eq("job position has been deleted")
  #     end
  #     it "destroy record from the DB" do
  #       db_size = JobPosition.all.size
  #       delete "/api/job_position/#{@job_position["resp"]["id"]}"

  #       expect(JobPosition.all.size).to eq(db_size - 1)
  #     end
  #   end
  #   context "request fails" do
  #     it "returns a 404 status" do
  #       delete "/api/job_position/#{@job_position["resp"]["id"] + 1}"

  #       expect(response).to have_http_status(404)
  #     end
  #     it "returns an error message on JSON" do
  #       delete "/api/job_position/#{@job_position["resp"]["id"] + 1}"
  #       resp_json = JSON.parse(response.body)

  #       expect(resp_json["resp"]).to eq("job position can't be found")
  #     end
  #   end
  # end
end
