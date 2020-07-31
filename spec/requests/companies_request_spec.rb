require "rails_helper"

RSpec.describe "Companies", type: :request do
  before(:all) do
    @params = get_company_params
    @invlaid_parmas = get_invalid_cpmpany_params
  end

  describe "POST /api/companies" do
    context "request is successful" do
      it "returns a 201 status" do
        post "/api/companies", params: @params

        expect(response).to have_http_status(201)
      end
      it "returns an instance of the Company model on JSON" do
        post "/api/companies", params: @params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to match(get_company_matcher(resp_json["resp"]["id"]))
      end
      it "saves the company on the DB" do
        db_size = Company.all.size
        post "/api/companies", params: @params

        expect(Company.all.size).to eq(db_size + 1)
      end
    end
    context "request fails" do
      it "returns a 400 status" do
        post "/api/companies", params: @invlaid_parmas

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        post "/api/companies", params: @invlaid_parmas
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to include("name")
        expect(resp_json["resp"]).to_not eq({})
      end
    end
  end
  describe "GET /api/company/:id" do
    before(:each) do
      @company = create_company
    end
    context "request is successful" do
      it "returns a 200 status" do
        get "/api/company/#{@company["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns an instance of the Company model on JSON based on the id provided" do
        get "/api/company/#{@company["id"]}"
        resp_json = JSON.parse(response.body)
        matcher = get_company_matcher(@company["id"])

        expect(resp_json["resp"]).to eq(matcher)
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        get "/api/company/#{@company["id"] + 1}"

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        get "/api/company/#{@company["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("company can't be found")
      end
    end
  end
  describe "PUT /api/company/:id" do
    before(:each) do
      @company = create_company
      @update_params = { "name" => "Homebase" }
      @update_invalid_params = { "name" => nil }
    end
    context "request is successful" do
      it "returns a 200 status" do
        put "/api/company/#{@company["id"]}", params: @update_params

        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the Company model on JSON" do
        put "/api/company/#{@company["id"]}", params: @update_params
        resp_json = JSON.parse(response.body)
        matcher = get_company_matcher(@company["id"])
        matcher["name"] = @update_params["name"]

        expect(resp_json["resp"]).to match(matcher)
      end
    end
    context "request fails(invalid params)" do
      it "returns a 400 status" do
        put "/api/company/#{@company["id"]}", params: @update_invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors of JSON" do
        put "/api/company/#{@company["id"]}", params: @update_invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to include("name")
        expect(resp_json["resp"]).to_not eq({})
      end
    end
    context "request fails(invalid id)" do
      it "returns a 404 status" do
        put "/api/company/#{@company["id"] + 1}", params: @update_params

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        put "/api/company/#{@company["id"] + 1}", params: @update_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("company can't be found")
      end
    end
  end
  describe "DELETE /api/company/:id" do
    before(:each) do
      @company = create_company
    end
    context "request is successful" do
      it "returns a 200 status" do
        delete "/api/company/#{@company["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns a confirmatino message on JSON" do
        delete "/api/company/#{@company["id"]}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("company has been deleted")
      end
      it "destroy record from the DB" do
        db_size = Company.all.size
        delete "/api/company/#{@company["id"]}"

        expect(Company.all.size).to eq(db_size - 1)
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        delete "/api/company/#{@company["id"] + 1}"

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        delete "/api/company/#{@company["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("company can't be found")
      end
    end
  end
end
