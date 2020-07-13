require "rails_helper"

RSpec.describe "Boards", type: :request do
  before(:each) do
    # This create an instance of the User model
    # create_test_instances.rb
    @user = defaul_user_instance

    @params = {
      name: "My first board",
      user_id: @user.id,
    }

    @resp_matcher = {
      "name" => @params[:name],
      "user_id" => @params[:user_id],
    }
  end

  describe "POST /boards" do
    context "if request is succesful when passing params" do
      it "returns http success" do
        post "/boards", params: @params
        expect(response).to have_http_status(201)
      end

      it "saves the instance on the db" do
        db_size = Board.all.size
        post "/boards", params: @params
        expect(Board.all.size).to_not eql(db_size)
      end

      it "returns an instance of the Board in JSON" do
        post "/boards", params: @params
        json = JSON.parse(response.body)
        @resp_matcher["id"] = json["resp"]["id"]

        expect(json["resp"]).to match(@resp_matcher)
      end
    end

    context "if request fails" do
      it "returns http success" do
        @params[:name] = nil
        post "/boards", params: @params

        expect(response).to have_http_status(400)
      end

      it "return an object of error messages" do
        @params[:name] = nil
        post "/boards", params: @params
        json = JSON.parse(response.body)

        expect(json["resp"]).to_not match({})
      end
    end
  end

  describe "GET /board/:id" do
    before(:each) do
      post "/boards", params: @params
      @json = JSON.parse(response.body)
    end

    context "If request is succesful" do
      it "returns a 200 http status" do
        get "/board/#{@json["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end

      it "returns an instance of Board on JSON" do
        get "/board/#{@json["resp"]["id"]}"
        json_board = JSON.parse(response.body)
        @resp_matcher["id"] = @json["resp"]["id"]

        expect(json_board["resp"]).to match(@resp_matcher)
      end
    end

    context "If request fails" do
      it "returns a 400 http status" do
        get "/board/#{@json["resp"]["id"] + 1}"

        expect(response).to have_http_status(400)
      end

      it "returns an error message" do
        get "/board/#{@json["resp"]["id"] + 1}"
        json_board = JSON.parse(response.body)

        expect(json_board["resp"]).to eql("Board can't be found")
      end
    end
  end

  describe "PUT /board/:id" do
    before(:each) do
      post "/boards", params: @params
      @json = JSON.parse(response.body)
    end

    context "If request is succesful" do
      it "returns a 200 http status" do
        put "/board/#{@json["resp"]["id"]}"
        expect(response).to have_http_status(200)
      end

      it "returns an updated instance of the Board on JSON" do
        @params["name"] = "different name"
        put "/board/#{@json["resp"]["id"]}", params: @params
        json_board = JSON.parse(response.body)
        @resp_matcher["id"] = @json["resp"]["id"]
        @resp_matcher["name"] = "different name"

        expect(json_board["resp"]).to match(@resp_matcher)
      end
    end

    context "If request fails" do
      it "returns a 400 http status if params are not valid" do
        @params["name"] = nil
        put "/board/#{@json["resp"]["id"]}", params: @params

        expect(response).to have_http_status(400)
      end

      it "return an object of error messages if 400 error" do
        @params["name"] = nil
        put "/board/#{@json["resp"]["id"]}", params: @params
        json_board = JSON.parse(response.body)

        expect(json_board["resp"]).to_not match({})
      end

      it "returns a 404 http status if board can't be found" do
        put "/board/#{@json["resp"]["id"] + 1}", params: @params

        expect(response).to have_http_status(404)
      end

      it "returns an error message if 404 error" do
        put "/board/#{@json["resp"]["id"] + 1}", params: @params
        json_board = JSON.parse(response.body)

        expect(json_board["resp"]).to eql("Board can't be found")
      end
    end
  end

  describe "DELETE /board/:id" do

    before(:each) do
        post "/boards", params: @params
        @json = JSON.parse(response.body)
    end

    context "If request is succesful" do

      it "returns a 200 http status" do
        delete "/board/#{@json["resp"]["id"]}"

        expect(response).to have_http_status(200)
      end

      it "returns a confirmation message" do
        delete "/board/#{@json["resp"]["id"]}"
        json_board = JSON.parse(response.body)

        expect(json_board["resp"]).to eql("Board has been deleted")
      end
    end

    context "If request fails" do
      it "returns a 404 htto status" do
        delete "/board/#{@json["resp"]["id"] + 1}"

        expect(response).to have_http_status(404)
      end

      it "returns an error message" do
        delete "/board/#{@json["resp"]["id"] + 1}"
        json_board = JSON.parse(response.body)

        expect(json_board["resp"]).to eql("Board can't be found")
      end
    end
  end
end
