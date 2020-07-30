require "rails_helper"

RSpec.describe "LeadEmails", type: :request do
  before(:each) do
    @user = create_user
    @company = create_company
    @board = create_board(@user.id)
    @column = create_column(@board.id)
    @lead = create_lead(@column.id, @company.id)
    @job_position = create_job_position(@user.id, @company.id)
    @lead_email_params = get_lead_email_params(@lead.id, @job_position.id)
    @lead_email_invalid_params = get_lead_email_invalid_params(@lead.id, @job_position.id)
  end

  describe "POST /lead_emails" do
    context "request is successful" do
      it "returns a 201 status" do
        post "/lead_emails", params: @lead_email_params

        expect(response).to have_http_status(201)
      end
      it "returns an instance of the LeadEmail model on JSON" do
        post "/lead_emails", params: @lead_email_params
        resp_json = JSON.parse(response.body)
        matcher = get_lead_email_matcher(@lead.id, @job_position.id, resp_json["resp"]["id"])

        expect(resp_json["resp"]).to match(matcher)
      end
      it "saves the lead_email on the DB" do
        db_size = LeadEmail.all.size
        post "/lead_emails", params: @lead_email_params

        expect(LeadEmail.all.size).to eq(db_size + 1)
      end
    end
    context "request fails" do
      it "returns a 400 status" do
        post "/lead_emails", params: @lead_email_invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        post "/lead_emails", params: @lead_email_invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to include("email")
        expect(resp_json["resp"]).to_not match({})
      end
    end
  end
  describe "GET /lead_email/:id" do
    before(:each) do
      post "/lead_emails", params: @lead_email_params
      @resp_lead_email = JSON.parse(response.body)
    end
    context "request is successful" do
      it "returns a 200 status" do
        get "/lead_email/#{@resp_lead_email["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns an instance of the LeadEmail model on JSON based on the id provided" do
        get "/lead_email/#{@resp_lead_email["resp"]["id"]}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to match(@resp_lead_email["resp"])
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        get "/lead_email/#{@resp_lead_email["resp"]["id"] + 1}"

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        get "/lead_email/#{@resp_lead_email["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("lead email can't be found")
      end
    end
  end
  describe "PUT /lead_email/:id" do
    before(:each) do
      post "/lead_emails", params: @lead_email_params
      @resp_lead_email = JSON.parse(response.body)
      @update_valid_params = { "email" => "new_email@example.com" }
      @update_invalid_params = { "email" => "new_invalid_email@examplecom" }
    end
    context "request is successful" do
      it "returns a 200 status" do
        put "/lead_email/#{@resp_lead_email["resp"]["id"]}", params: @update_valid_params

        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the LeadEmail model on JSON" do
        put "/lead_email/#{@resp_lead_email["resp"]["id"]}", params: @update_valid_params
        resp_json = JSON.parse(response.body)
        matcher = @resp_lead_email["resp"].clone
        matcher["email"] = @update_valid_params["email"]

        expect(resp_json["resp"]).to match(matcher)
      end
    end
    context "request fails(invalid params)" do
      it "returns a 400 status" do
        put "/lead_email/#{@resp_lead_email["resp"]["id"]}", params: @update_invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors of JSON" do
        put "/lead_email/#{@resp_lead_email["resp"]["id"]}", params: @update_invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to include("email")
        expect(resp_json["resp"]).to_not eq({})
      end
    end
    context "request fails(invalid id)" do
      it "returns a 404 status" do
        put "/lead_email/#{@resp_lead_email["resp"]["id"] + 1}", params: @update_valid_params

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        put "/lead_email/#{@resp_lead_email["resp"]["id"] + 1}", params: @update_valid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("lead email can't be found")
      end
    end
  end
  describe "DELETE /lead_email/:id" do
    before(:each) do
      post "/lead_emails", params: @lead_email_params
      @resp_lead_email = JSON.parse(response.body)
    end
    context "request is successful" do
      it "returns a 200 status" do
        delete "/lead_email/#{@resp_lead_email["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns a confirmatino message on JSON" do
        delete "/lead_email/#{@resp_lead_email["resp"]["id"]}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("lead email has been deleted")
      end
      it "destroy record from the DB" do
        db_size = LeadEmail.all.size
        delete "/lead_email/#{@resp_lead_email["resp"]["id"]}"

        expect(LeadEmail.all.size).to eq(db_size - 1)
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        delete "/lead_email/#{@resp_lead_email["resp"]["id"] + 1}"

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        delete "/lead_email/#{@resp_lead_email["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("lead email can't be found")
      end
    end
  end
end
