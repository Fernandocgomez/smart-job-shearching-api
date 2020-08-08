require_relative 'params_helper'
module ControllerHelper
    extend ParamsHelper 

    # <----------- Global --------------->

    def parse_resp_on_json(response)
        JSON.parse(response.body)["resp"]
    end

    # <----------- Auth --------------->

    def get_auth_token(user_id)
        token =  JWT.encode({user_id: user_id}, "jobhunting", "HS256")
        {"Authorization" => "Bearer " + token}
    end

    # <----------- User --------------->

    @@user_params = ParamsHelper.get_user_params

    def get_user_params(type)
        params = @@user_params.clone
        case type
        when "valid"
            return params
        when "invalid"
            params['username'] = nil
            return params
        else
            return nil
        end
    end

    def get_user_matcher(user_id)
        params = @@user_params.clone
        params.except!("password")
        params.except!("password_confirmation")
        params['id'] = user_id
        params
    end

    # <----------- Board --------------->

    @@board_params = ParamsHelper.get_board_params

    def get_board_params(type, user_id)
        params = @@board_params.clone
        params['user_id'] = user_id
        case type
        when "valid"
            return params
        when "invalid"
            params['name'] = nil
            return params
        else
            return nil
        end
    end

    def get_board_matcher(board_id, user_id)
        matcher = @@board_params.clone
        matcher['id'] = board_id
        matcher['user_id'] = user_id
        matcher
    end

    # <----------- Column --------------->

    @@column_params = ParamsHelper.get_column_params

    def get_column_params(type, board_id)
        params = @@column_params.clone
        params['board_id'] = board_id
        case type
        when "valid"
            return params
        when "invalid"
            params['name'] = nil
            return params
        else
            return nil
        end
    end

    def get_column_matcher(column_id, board_id)
        matcher = @@column_params.clone
        matcher['id'] = column_id
        matcher['board_id'] = board_id
        matcher
    end

end