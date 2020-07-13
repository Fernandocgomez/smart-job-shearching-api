# This module creates instances of our models for our test files
module CreateTestInstances

    @@user_params = {
        username: "fernandocgomez",
        email: "fernandocgomez@live.com",
        password_digest: "Ilovemytacos32%",
        password_digest_confirmation: "Ilovemytacos32%",
        first_name: "Fernando",
        last_name: "Gomez",
        street_address: "11900 City Park Central Ln",
        street_address_2: "7210",
        city: "Houston",
        state: "Tx",
        zipcode: "77047"
    }

    def defaul_user_instance
        User.create(@@user_params) 
    end

    def deaful_user_instance_without_validations 
        User.create!(@@user_params)
    end

    def get_valid_user_params
        @@user_params
    end

    def default_board(id)
        Board.create(
            name: "My first board",
            user_id: id
        )
    end
end