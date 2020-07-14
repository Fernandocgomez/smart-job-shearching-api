require "rails_helper"

RSpec.describe "Columns", type: :request do
  before(:each) do
    # This create an instance of the User model
    # create_test_instances.rb
    @user = defaul_user_instance
    @board = default_board(@user.id)
    @params = { name: "My first column", position: 0, board_id: @board.id }
    @matching_return = { "id" => nil, "name" => "My first column", "position" => 0, "board_id" => @board.id }
  end

  describe "POST /columns" do
    context "if request is succesful" do
      it "returns http 201 status" do
        post "/columns", params: @params

        expect(response).to have_http_status(201)
      end
      it "returns an instance of the Column model in JSON" do
        post "/columns", params: @params
        resp_parsed = JSON.parse(response.body)
        @matching_return["id"] = resp_parsed["resp"]["id"]

        expect(resp_parsed["resp"]).to match(@matching_return)
      end

      it "adds a new record on the DB" do
        db_size = Column.all.size
        post "/columns", params: @params

        expect(Column.all.size).to eql(db_size + 1)
      end
    end
    context "if request fails" do
      it "returns http 400" do
        @params[:name] = nil
        post "/columns", params: @params

        expect(response).to have_http_status(400)
      end
      it "returns an object of error messages in JSON" do
        @params[:name] = nil
        post "/columns", params: @params
        resp_parsed = JSON.parse(response.body)

        expect(resp_parsed["resp"]).to_not match({})
        expect(resp_parsed["resp"]).to include("name")
      end
    end
  end

  describe "PUT /column/:id" do
    before(:each) do
        column_to_update = post "/columns", params: @params
        @resp_parse_of_column_to_update = JSON.parse(response.body)
    end
    context "if request is succesful" do
      it "returns a 200 http status" do
        @params["name"] = "New updated name"
        put "/column/#{@resp_parse_of_column_to_update["resp"]["id"]}", params: @params

        expect(response).to have_http_status(200)
      end
      it "returns the updated instance of Column in JSON" do
        @params["name"] = "New updated name"
        put "/column/#{@resp_parse_of_column_to_update["resp"]["id"]}", params: @params
        resp_parsed = JSON.parse(response.body)
        @matching_return["id"] = @resp_parse_of_column_to_update["resp"]["id"]
        @matching_return["name"] = "New updated name"

        expect(resp_parsed["resp"]).to match(@matching_return)
      end
    end
    context "if request fails becuase the column cannot be found" do
      it "returns a 404 http status" do
        @params["name"] = "New updated name"
        put "/column/#{@resp_parse_of_column_to_update["resp"]["id"] + 1}", params: @params

        expect(response).to have_http_status(404)
      end
      it "returns an error message in JSON" do
        @params["name"] = "New updated name"
        put "/column/#{@resp_parse_of_column_to_update["resp"]["id"] + 1}", params: @params
        resp_parsed = JSON.parse(response.body)

        expect(resp_parsed["resp"]).to eql("column can't be found")
      end
    end
    context "if request fails becuase the params are not valid" do
      it "returns a 400 http status" do
        @params["name"] = nil
        put "/column/#{@resp_parse_of_column_to_update["resp"]["id"]}", params: @params

        expect(response).to have_http_status(400)
      end
      it "returns an object of error messages in JSON" do
        @params["name"] = nil
        put "/column/#{@resp_parse_of_column_to_update["resp"]["id"]}", params: @params

        resp_parsed = JSON.parse(response.body)

        expect(resp_parsed["resp"]).to_not match({})
        expect(resp_parsed["resp"]).to include("name")
      end
    end
  end

  describe "DELETE /column/:id" do
    before(:each) do
      column_to_update = post "/columns", params: @params
      @resp_parse_of_column_to_update = JSON.parse(response.body)
    end
    context "if request is succesful" do
      it "returns a 200 http status" do
        delete "/column/#{@resp_parse_of_column_to_update["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end
      it "return a confirmation message in JSON" do
        delete "/column/#{@resp_parse_of_column_to_update["resp"]["id"]}"
        resp_parsed = JSON.parse(response.body)

        expect(resp_parsed["resp"]).to eql("column has been deleted")
      end
    end
    context "if request fails because column cannot be found on DB" do
      it "return a 404 http status" do
        delete "/column/#{@resp_parse_of_column_to_update["resp"]["id"] + 1}"
        expect(response).to have_http_status(404)
      end
      it "returns an error message in JSON" do
        delete "/column/#{@resp_parse_of_column_to_update["resp"]["id"] + 1}"
        resp_parsed = JSON.parse(response.body)

        expect(resp_parsed["resp"]).to eql("column can't be found")
      end
    end
  end
end
