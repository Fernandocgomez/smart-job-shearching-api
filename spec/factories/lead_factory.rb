FactoryBot.define do 
    factory :lead do 
        first_name {"Andrew"}
        last_name {"Sprague"}
        picture_url {"https://media-exp1.licdn.com/dms/image/C5603AQE56P4YUjdGiw/profile-displayphoto-shrink_100_100/0?e=1599696000&v=beta&t=ZI3-yK0vAH9NH-XSH5Xq70G0nKsdBUHhAjeYEqd1w8s" }
        linkedin_url {"/in/andrew-sprague-cfa/"}
        status {"new"}
        notes {"write a note..."}
        email {"asprague@outlook.com"}
        phone_number {"3462600832"} 
        position {0}
        column_id {nil}
        company_id {nil}
    end
end 