require "rails_helper"

RSpec.describe "Columns", type: :request do
  before(:each) do
    # This create an instance of the User model
    # create_test_instances.rb
    @user = create_user
    @board = create_board(@user.id)
    @params = get_column_params(@board.id)
    @invalid_params = get_invalid_column_params(@board.id, nil)
    @matcher = { "id" => nil, "name" => "My first column", "position" => 0, "board_id" => @board.id }
  end

  describe "POST /columns" do
    context "request is succesful" do
      it "returns a 201 status" do
        post "/columns", params: @params

        expect(response).to have_http_status(201)
      end
      it "returns an instance of the Column model in JSON" do
        post "/columns", params: @params
        resp_json = JSON.parse(response.body)
        @matcher["id"] = resp_json["resp"]["id"]

        expect(resp_json["resp"]).to match(@matcher)
      end

      it "saves the instance of the Column on the DB" do
        db_size = Column.all.size
        post "/columns", params: @params

        expect(Column.all.size).to eql(db_size + 1)
      end
    end
    context "request fails" do
      it "returns a 400 status" do
        post "/columns", params: @invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of errors on JSON" do
        post "/columns", params: @invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to_not match({})
        expect(resp_json["resp"]).to include("name")
      end
    end
  end

  describe "PUT /column/:id" do
    before(:each) do
      post "/columns", params: @params
      # @column_resp = JSON.parse(response.body)
      @column_resp = JSON.parse(response.body)
      @update_params = { "name" => "New updated name" }
      @update_invalid_params = { "name" => "M" }
    end
    context "request is succesful" do
      it "returns a 200 status" do
        put "/column/#{@column_resp["resp"]["id"]}", params: @update_params

        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of the Column model on JSON" do
        put "/column/#{@column_resp["resp"]["id"]}", params: @update_params
        resp_json = JSON.parse(response.body)
        @matcher["id"] = @column_resp["resp"]["id"]
        @matcher["name"] = @update_params["name"]

        expect(resp_json["resp"]).to match(@matcher)
      end
    end
    context "request fails(invalid id)" do
      it "returns a 404 status" do
        put "/column/#{@column_resp["resp"]["id"] + 1}", params: @update_params

        expect(response).to have_http_status(404)
      end
      it "returns an error message on JSON" do
        put "/column/#{@column_resp["resp"]["id"] + 1}", params: @update_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eql("column can't be found")
      end
    end
    context "request fails(invalid paramas)" do
      it "returns a 400 status" do
        put "/column/#{@column_resp["resp"]["id"]}", params: @update_invalid_params

        expect(response).to have_http_status(400)
      end
      it "returns an object of error messages in JSON" do
        put "/column/#{@column_resp["resp"]["id"]}", params: @update_invalid_params

        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to_not match({})
        expect(resp_json["resp"]).to include("name")
      end
    end
  end

  describe "DELETE /column/:id" do
    before(:each) do
      post "/columns", params: @params
      @column_resp = JSON.parse(response.body)
    end
    context "request is successful" do
      it "returns a 200 status" do
        delete "/column/#{@column_resp["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "returns a confirmation message on JSON" do
        delete "/column/#{@column_resp["resp"]["id"]}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eql("column has been deleted")
      end
    end
    context "request fails" do
      it "returns a 404 status" do
        delete "/column/#{@column_resp["resp"]["id"] + 1}"
        expect(response).to have_http_status(404)
      end
      it "rreturns an error message on JSON" do
        delete "/column/#{@column_resp["resp"]["id"] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eql("column can't be found")
      end
    end
  end
end
