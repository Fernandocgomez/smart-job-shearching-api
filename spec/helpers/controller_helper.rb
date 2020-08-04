module ControllerHelper 

    # <----------- User --------------->

    @@user_params = {
        "username" => "fernandocgomez",
        "email" => "fernandocgomez@live.com",
        "password" => "Ilovemytacos32%",
        "password_confirmation" => "Ilovemytacos32%",
        "first_name" => "Fernando",
        "last_name" => "Gomez",
        "city" => "Houston",
        "state" => "Tx",
        "zipcode" => "77047",
    }

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

    def get_auth_token(user_id)
        token =  JWT.encode({user_id: user_id}, "jobhunting", "HS256")
        {"Authorization" => "Bearer " + token}
    end



    
end