require_relative 'params_helper'
module ControllerHelper
    extend ParamsHelper 

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
            return params
        end
    end

    def get_user_matcher(user_id)
        params = @@user_params.clone
        params.except!("password")
        params.except!("password_confirmation")
        params['id'] = user_id
        params
    end

    # <----------- Auth --------------->

    def get_auth_token(user_id)
        token =  JWT.encode({user_id: user_id}, "jobhunting", "HS256")
        {"Authorization" => "Bearer " + token}
    end

    

end