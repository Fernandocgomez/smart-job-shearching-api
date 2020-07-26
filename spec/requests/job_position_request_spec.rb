require "rails_helper"

RSpec.describe "JobPositions", type: :request do
  before(:each) do
    @user = create_user
    @company = create_company
    @params = get_job_position_params(@user.id, @company.id)
    @invalid_params = get_job_position_invalid_params(@user.id, @company.id, "TXX")
  end
  describe "POST /job_positions" do
    context "request is successful" do
      it "returns a 201 status" do
        post "/job_positions", params: @params

        expect(response).to have_http_status(201)
      end
      it "returns an instance of the JobPosition model on JSON" do
        post "/job_positions", params: @params
        resp_json = JSON.parse(response.body)
        matcher = get_job_position_matcher(@user.id, @company.id, resp_json["resp"]["id"])

        expect(resp_json["resp"]).to match(matcher)
      end
      it "saves the job_position on the DB" do
        db_size = JobPosition.all.size
        post "/job_positions", params: @params

        expect(JobPosition.all.size).to eq(db_size + 1)
      end
    end
    context "request fails" do
      it "returns a 400 status" do
        post "/job_positions", params: @invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        post "/job_positions", params: @invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to include("state")
        expect(resp_json["resp"]).to_not eq({})
      end
    end
  end
  describe "GET /job_position/:id" do
    before(:each) do
      post "/job_positions", params: @params
      @job_position = JSON.parse(response.body)
    end
    context "request is successful" do
      it "returns a 200 status" do
        get "/job_position/#{@job_position["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns an instance of the JobPosition model on JSON based on the id provided" do
        get "/job_position/#{@job_position["resp"]["id"]}"
        resp_json = JSON.parse(response.body)
        matcher = get_job_position_matcher(@user.id, @company.id, resp_json["resp"]["id"])

        expect(resp_json["resp"]).to match(matcher)
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        get "/job_position/#{@job_position["resp"]["id"] + 1}"

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        get "/job_position/#{@job_position["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("job position can't be found")
      end
    end
  end
  describe "PUT /job_position/:id" do
    before(:each) do
      post "/job_positions", params: @params
      @job_position = JSON.parse(response.body)
      @changes = { "name" => "New name" }
      @invalid_changes = { "name" => nil }
    end
    context "request is successful" do
      it "returns a 200 status" do
        put "/job_position/#{@job_position["resp"]["id"]}", params: @changes

        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the JobPosition model on JSON" do
        put "/job_position/#{@job_position["resp"]["id"]}", params: @changes
        resp_json = JSON.parse(response.body)
        matcher = get_job_position_matcher(@user.id, @company.id, resp_json["resp"]["id"])
        matcher["name"] = @changes["name"]

        expect(resp_json["resp"]).to match(matcher)
      end
    end
    context "request fails(invalid params)" do
      it "returns a 400 status" do
        put "/job_position/#{@job_position["resp"]["id"]}", params: @invalid_changes

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors of JSON" do
        put "/job_position/#{@job_position["resp"]["id"]}", params: @invalid_changes
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to_not eq({})
        expect(resp_json["resp"]).to include("name")
      end
    end
    context "request fails(invalid id)" do
      it "returns a 404 status" do
        put "/job_position/#{@job_position["resp"]["id"] + 1}", params: @changes

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        put "/job_position/#{@job_position["resp"]["id"] + 1}", params: @changes
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("job position can't be found")
      end
    end
  end
  describe "DELETE /job_position/:id" do
    before(:each) do
      post "/job_positions", params: @params
      @job_position = JSON.parse(response.body)
    end
    context "request is successful" do
      it "returns a 200 status" do
        delete "/job_position/#{@job_position["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns a confirmatino message on JSON" do
        delete "/job_position/#{@job_position["resp"]["id"]}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("job position has been deleted")
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        delete "/job_position/#{@job_position["resp"]["id"] + 1}"

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        delete "/job_position/#{@job_position["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("job position can't be found")
      end
    end
  end
end
