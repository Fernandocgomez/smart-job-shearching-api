FactoryBot.define do 
    factory :lead_email do 
        email {"example@example.com"}
        subject {"1st Software Engineer Position"}
        email_body {"Hello, I am contacting you regarding to the front end position"}
        sent {false} 
        open {false}
        lead_id {nil}
        job_position_id {nil}
    end
end