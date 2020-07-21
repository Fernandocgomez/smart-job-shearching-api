require "rails_helper"
RSpec.describe "Boards", type: :request do
  before(:each) do
    # This create an instance of the User model
    # create_test_instances.rb
    @user = defaul_user_instance
    @params = get_board_params(@user['id'])
    @matcher = @params
    @invalid_params = get_board_invalid_params
  end

  describe 'POST /boards' do
    context 'request is succesful' do
      it 'returns a 201 status' do
        post "/boards", params: @params
        expect(response).to have_http_status(201)
      end
      it 'returns an instance of the Board model on JSON' do
        post "/boards", params: @params
        resp_json = JSON.parse(response.body)
        @matcher['id'] = resp_json['resp']['id']

        expect(resp_json['resp']).to match(@matcher)
      end
      it 'saves the instance of the Board on the DB' do
        db_size = Board.all.size
        post "/boards", params: @params

        expect(Board.all.size).to eq(db_size + 1)
      end
    end
    context 'request fails' do
      it 'returns a 400 status' do
        post "/boards", params: @invalid_params
        expect(response).to have_http_status(400)
      end
      it 'returns an object of errors on JSON' do
        post "/boards", params: @invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to_not eq({})
      end
    end
  end
  describe 'GET /board/:id' do
    before(:each) do
      post "/boards", params: @params
      @board_resp = JSON.parse(response.body)
    end
    context 'request is successful' do
      it 'returns a 200 status' do
        get "/board/#{@board_resp['resp']['id']}"
        expect(response).to have_http_status(200)
      end
      it 'returns an instance of the Board model on JSON basedon the id provided' do
        get "/board/#{@board_resp['resp']['id']}"
        resp_json = JSON.parse(response.body)

        expect(resp_json['resp']).to match(@board_resp['resp'])
      end
    end
    context 'request fails' do
      it 'returns a 400 status' do
        get "/board/#{@board_resp['resp']['id'] + 1}"
        expect(response).to have_http_status(400)
      end
      it 'returns an error message on JSON' do
        get "/board/#{@board_resp['resp']['id'] + 1}"
        resp_json = JSON.parse(response.body)
        expect(resp_json['resp']).to eq("board can't be found")
      end
    end
  end
  describe 'PUT /board/:id' do
    before(:each) do
      post "/boards", params: @params
      @board_resp = JSON.parse(response.body)
      @update_params = {"name" => "My newest board"}
      @update_invalid_params = {"name" => "M"}
    end
    context 'request is succesful' do
      it 'returns a 200 status' do
        put "/board/#{@board_resp['resp']['id']}", params: @update_params
        expect(response).to have_http_status(200)
      end
      it 'returns the updated instance of the Board model on JSON' do
        put "/board/#{@board_resp['resp']['id']}", params: @update_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]["name"]).to match(@update_params["name"])
      end
    end
    context 'request fails(invalid params)' do
      it 'returns a 400 status' do
        put "/board/#{@board_resp['resp']['id']}", params: @update_invalid_params
        expect(response).to have_http_status(400)
      end
      it 'returns an object of errors on JSON' do
        put "/board/#{@board_resp['resp']['id']}", params: @update_invalid_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to_not eq({})
      end
      
    end
    context 'request fails(invalid id)' do
      it 'returns a 4040 status' do
        put "/board/#{@board_resp['resp']['id'] + 1}", params: @update_params

        expect(response).to have_http_status(404)
      end
      it 'returns an error message on JSON' do
        put "/board/#{@board_resp['resp']['id'] + 1}", params: @update_params
        resp_json = JSON.parse(response.body)

        expect(resp_json["resp"]).to eq("board can't be found")
      end 
    end
  end
  describe 'DELETE /board/:id' do
    before(:each) do
      post "/boards", params: @params
      @board_resp = JSON.parse(response.body)
    end
    context 'request is successful' do
      it 'returns a 200 status' do
        delete "/board/#{@board_resp['resp']['id']}"
        expect(response).to have_http_status(200)
      end
      it 'returns a confirmation message on JSON' do
        delete "/board/#{@board_resp['resp']['id']}"
        resp_json = JSON.parse(response.body)

        expect(resp_json['resp']).to eq("board has been deleted")
      end
    end
    context 'request fails' do
      it 'returns a 404 status' do
        delete "/board/#{@board_resp['resp']['id'] + 1}"
        expect(response).to have_http_status(404)
      end
      it 'returns an error message on JSON' do
        delete "/board/#{@board_resp['resp']['id'] + 1}"
        resp_json = JSON.parse(response.body)

        expect(resp_json['resp']).to eq("board can't be found")
      end
    end
  end
end