module ParamsHelper 

    def self.get_user_params
        {
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
    end

    def self.get_company_params 
        {
            "name" => "Just Energy",
            "linkedin_url" => "/company/just-energy_2/life/",
            "website" => "wwww.companyxwy.com",
            "about" => "about the company", 
            "user_id" => nil
        }
    end

    def self.get_lead_params
        {
            "first_name" => "Andrew",
            "last_name" => "Sprague", 
            "picture_url" => "https://media-exp1.licdn.com/dms/image/C5603AQE56P4YUjdGiw/profile-displayphoto-shrink_100_100/0?e=1599696000&v=beta&t=ZI3-yK0vAH9NH-XSH5Xq70G0nKsdBUHhAjeYEqd1w8s", 
            "linkedin_url" => "/in/andrew-sprague-cfa/", 
            "status" => "new", 
            "notes" => "write a note...", 
            "email" => "asprague@outlook.com",
            "phone_number" => "3462600832", 
            "position" => 0,
            "column_id" => nil,
            "company_id" => nil
        }
    end

    def self.get_job_position_params
        {
            "name" => "Front End Developer", 
            "description" => "Kettle is seeking a front-end developer with a passion for solving problems and making creative concepts a reality through clean, maintainable code. The client you’d be working alongside has been celebrated for its iconic design and groundbreaking engineering. And in the dev community they’re known for a meticulous approach to code that’s so pure, it’s considered an art in and of itself.
        
            We’d Like To Know That You Can
            
            3+ years experience in front-end web development
            Comprehensive knowledge of HTML, CSS, and JavaScript
            Excellent verbal/written communication and time management skills
            Proven debugging and troubleshooting skills
            
            The Right Candidate Should Also Have
            
            An insatiable curiosity for new techniques and a razor-sharp eye for detail
            A love for programming from scratch with object-oriented JavaScript (DOM literacy is a must!)
            You’re serious about your work, but don’t take yourself too seriously
            A passion for taking part in open source projects
            
            Why It’s An Awesome Gig
            
            Make JavaScript matter. Help elevate JavaScript to the level of its more respected brethren through unit tests, headless testing, and by contributing to core libraries authored and maintained by many of the world's best engineers.
            Take part in emerging methodologies. Author and contribute to a slew of proprietary implementations of the latest front-end development methodologies — custom-built for one of the world’s most widely-watched tech companies.
            Lead the charge in accessibility. Be on the forefront of implementing truly accessible content at scale. And with this client, ‘at scale’ means really, really big.
            Craft pixel-perfect, butter-smooth animations. Leverage the team's shared knowledge to exploit all the quirks of modern browsers for animations that perform consistently and beautifully.
            Never open Photoshop again. Ever. We’re serious. And yes, it’s awesome. This client has entire teams dedicated to slicing and exporting all images before we ever begin development.
            And build new skills day after day. Get allocated time for personal development and exploration in a highly collaborative, growth-facilitating environment — complete with manager/peer code-reviews, and exclusive dev talks and symposiums.
            
            Seniority Level
            
            Entry level
            
            Industry
            Computer Software
            Employment Type
            
            Part-time
            
            Job Functions
            Engineering  Information Technology",
            "city" => "Houston", 
            "state" => "TX", 
            "applied" => false, 
            "company_id" => nil
        }
    end

    def self.get_lead_email_params
        {
            "email" => "example@example.com", 
            "subject" => "1st Software Engineer Position",
            "email_body" => "Hello, I am contacting you regarding to the front end position", 
            "sent" => false, 
            "open" => false,
            "lead_id" => nil,
            "job_position_id" => nil
        }
    end

    def self.get_column_params 
        {
            "name" => "My first column",
            "position" => 0,
            "board_id" => nil
        }
    end

    def self.get_board_params
        {
            "name" => "My new board",
            "user_id" => nil,
        }
    end

end