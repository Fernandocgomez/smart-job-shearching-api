FactoryBot.define do 
    factory :user do 
        username {"fernandocgomez"}
        email {"fernandocgomez@live.com"}
        password {"Ilovemytacos32%"}
        password_confirmation {"Ilovemytacos32%"}
        first_name {"Fernando"}
        last_name {"Gomez"}
        city {"Houston"}
        state {"Tx"}
        zipcode {"77047"}
    end
end 