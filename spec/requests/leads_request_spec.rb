require "rails_helper"

RSpec.describe "Leads", type: :request do
  before(:each) do
    @user = create_user
    @board = create_board(@user.id)
    @column = create_column(@board.id)
    @company = create_company
    @params = get_lead_params(@column.id, @company.id)
    @invalid_params = get_invalid_lead_params(@column.id, @company.id)
    @lead_matcher = get_lead_matcher(@column.id, @company.id)
    @update_params = { "phone_number" => "3462600833" }
    @update_invalid_params = { "phone_number" => "346260083" }
  end
  describe "POST /api/leads" do
    context "request is successful" do
      it "returns a 201 status" do
        post "/api/leads", params: @params
        expect(response).to have_http_status(201)
      end
      it "returns an instance of the Lead model on JSON" do
        post "/api/leads", params: @params
        resp_json = JSON.parse(response.body)
        @lead_matcher["id"] = resp_json["resp"]["id"]

        expect(resp_json["resp"]).to match(@lead_matcher)
      end
      it "saves the lead on the DB" do
        db_size = Lead.all.size
        post "/api/leads", params: @params
        expect(Lead.all.size).to eq(db_size + 1)
      end
    end
    context "request fails" do
      it "returns a 400 status" do
        post "/api/leads", params: @invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        post "/api/leads", params: @invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to include("first_name")
        expect(resp_json["resp"]).to_not eq({})
      end
    end
  end
  describe "GET /api/lead/:id" do
    before(:each) do
      post "/api/leads", params: @params
      @lead = JSON.parse(response.body)
    end
    context "request is succesful" do
      it "returns a 200 status" do
        get "/api/lead/#{@lead["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns an instance of the Lead model on JSON based on the id provided" do
        get "/api/lead/#{@lead["resp"]["id"]}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to match(@lead["resp"])
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        get "/api/lead/#{@lead["resp"]["id"] + 1}"
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        get "/api/lead/#{@lead["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("lead can't be found")
      end
    end
  end
  describe "PUT /api/lead/:id" do
    before(:each) do
      post "/api/leads", params: @params
      @lead = JSON.parse(response.body)
    end
    context "request is succesful" do
      it "returns a 200 status" do
        put "/api/lead/#{@lead["resp"]["id"]}", params: @update_params

        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the User model on JSON" do
        put "/api/lead/#{@lead["resp"]["id"]}", params: @update_params
        resp_json = JSON.parse(response.body)
        @lead["resp"]["phone_number"] = @update_params["phone_number"]

        expect(resp_json["resp"]).to match(@lead["resp"])
      end
    end
    context "request fails(invalid params)" do
      it "returns a 400 status" do
        put "/api/lead/#{@lead["resp"]["id"]}", params: @update_invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors of JSON" do
        put "/api/lead/#{@lead["resp"]["id"]}", params: @update_invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to include("phone_number")
        expect(resp_json["resp"]).to_not eq({})
      end
    end
    context "request fails(invalid id)" do
      it "returns a 404 status" do
        put "/api/lead/#{@lead["resp"]["id"] + 1}", params: @update_params

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        put "/api/lead/#{@lead["resp"]["id"] + 1}", params: @update_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("lead can't be found")
      end
    end
  end
  describe "DELETE /api/lead/:id" do
    before(:each) do
      post "/api/leads", params: @params
      @lead = JSON.parse(response.body)
    end
    context "request is succesful" do
      it "returns a 200 status" do
        delete "/api/lead/#{@lead["resp"]["id"]}"
        expect(response).to have_http_status(200)
      end
      it "returns a confirmatino message on JSON" do
        delete "/api/lead/#{@lead["resp"]["id"]}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("lead has been deleted")
      end
      it "destroy record from the DB" do
        db_size = Lead.all.size
        delete "/api/lead/#{@lead["resp"]["id"]}"

        expect(Lead.all.size).to eq(db_size - 1)
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        delete "/api/lead/#{@lead["resp"]["id"] + 1}"
        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        delete "/api/lead/#{@lead["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("lead can't be found")
      end
    end
  end
end
