module RequestsHelper 

    @@user_params = {
        "username" => "fernandocgomez",
        "email" => "fernandocgomez@live.com",
        "password_digest" => "Ilovemytacos32%",
        "password_digest_confirmation" => "Ilovemytacos32%",
        "first_name" => "Fernando",
        "last_name" => "Gomez",
        "street_address" => "11900 City Park Central Ln", 
        "street_address_2" => "7210",
        "city" => "Houston",
        "state" => "Tx",
        "zipcode" => "77047"
    }

    @@user_invalid_params = {
        "username" => nil,
        "email" => "fernandocgomez@live.com",
        "password_digest" => "Ilovemytacos32%",
        "password_digest_confirmation" => "Ilovemytacos32%",
        "first_name" => "Fernando",
        "last_name" => "Gomez",
        "street_address" => "11900 City Park Central Ln", 
        "street_address_2" => "7210",
        "city" => "Houston",
        "state" => "Tx",
        "zipcode" => "77047"
    }

    @@user_matcher = {
        "username" => "fernandocgomez",
        "email" => "fernandocgomez@live.com",
        "first_name" => "Fernando",
        "last_name" => "Gomez",
        "street_address" => "11900 City Park Central Ln", 
        "street_address_2" => "7210",
        "city" => "Houston",
        "state" => "Tx",
        "zipcode" => "77047"
    }

    def create_user
        User.create(@@user_params)
    end

    def create_user_without_validations
        User.create!(@@user_params)
    end

    def get_user_params
        @@user_params
    end

    def get_user_matcher
        @@user_matcher
    end

    def get_user_invalid_params 
        @@user_invalid_params
    end




end