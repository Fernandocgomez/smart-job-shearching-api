module InstanceHelper


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
    matcher = @@user_params.clone
    matcher.except!("password")
    matcher.except!("password_confirmation")
    matcher
  end

  def get_user_invalid_params(invalid_param)
    params = @@user_params.clone
    params['username'] = invalid_param
    params
  end

  def self.seed_get_user_params
    @@user_params
  end

  def encode_token(playload)
    JWT.encode(playload, "jobhunting", "HS256")
  end

  # <----------- Board --------------->

  @@board_params = {
    "name" => "My new board",
    "user_id" => nil,
  }

  def get_board_params(user_id)
    params = @@board_params.clone
    params['user_id'] = user_id
    params
  end

  def get_board_invalid_params
    params = @@board_params.clone
    params
  end

  def create_board(user_id)
    params = @@board_params.clone
    params['user_id'] = user_id
    Board.create(params)
  end

  def self.seed_get_board_params(user_id)
    params = @@board_params.clone
    params['user_id'] = user_id
    params
  end

  # <----------- Column --------------->

  @@column_params = {
    "name" => "My first column",
    "position" => 0,
    "board_id" => nil
  }

  def get_column_params(board_id)
    params = @@column_params.clone
    params['board_id'] = board_id
    params
  end

  def get_invalid_column_params(board_id, invalid_param)
    params = @@column_params.clone
    params['name'] = invalid_param
    params['board_id'] = board_id
    params
  end

  def create_column(board_id)
    params = @@column_params.clone
    params['board_id'] = board_id
    Column.create(params)
  end

  def self.seed_get_column_params(board_id)
    params = @@column_params.clone
    params['board_id'] = board_id
    params
  end

  # <----------- Company ---------------->

  @@company_params = {
    "name" => "Just Energy",
    "linkedin_url" => "/company/just-energy_2/life/",
    "website" => "wwww.companyxwy.com",
    "about" => "about the company"
  }

  def create_company
    Company.create(@@company_params)
  end

  def get_company_params
    params = @@company_params.clone
    params
  end

  def get_invalid_cpmpany_params 
    params = @@company_params.clone
    params['name'] = nil
    params
  end

  def get_company_matcher(company_id)
    params = @@company_params.clone
    params['id'] = company_id
    params
  end

  def self.seed_get_company_params
    params = @@company_params.clone
    params
  end

  # <----------- Lead ---------------->

  @@lead_params = {
    "first_name" => "Andrew",
    "last_name" => "Sprague", 
    "picture_url" => "https://media-exp1.licdn.com/dms/image/C5603AQE56P4YUjdGiw/profile-displayphoto-shrink_100_100/0?e=1599696000&v=beta&t=ZI3-yK0vAH9NH-XSH5Xq70G0nKsdBUHhAjeYEqd1w8s", 
    "linkedin_url" => "/in/andrew-sprague-cfa/", 
    "status" => "new", 
    "notes" => "write a note...", 
    "email" => "asprague@outlook.com",
    "phone_number" => "3462600832", 
    "column_id" => nil,
    "company_id" => nil
  }

  def create_lead(column_id, company_id)
    params = @@lead_params.clone
    params['column_id'] = column_id
    params['company_id'] = company_id
    Lead.create(params)
  end

  def get_lead_params(column_id, company_id)
    params = @@lead_params.clone
    params['column_id'] = column_id
    params['company_id'] = company_id
    params
  end

  def get_invalid_lead_params(column_id, company_id)
    params = @@lead_params.clone
    params['column_id'] = column_id
    params['company_id'] = company_id
    params['first_name'] = nil
    params
  end

  def get_lead_matcher(column_id, company_id)
    params = @@lead_params.clone
    params['id'] = nil
    params['column_id'] = column_id
    params['company_id'] = company_id
    params
  end

  def self.seed_get_lead_params(column_id, company_id)
    params = @@lead_params.clone
    params['column_id'] = column_id
    params['company_id'] = company_id
    params
  end


  # <----------- JobPosition ---------------->

  @@job_position_params = {
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
    "user_id" => nil, 
    "company_id" => nil
  }

  def create_job_position(user_id, company_id)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    JobPosition.create(params)
  end

  def get_job_position_params(user_id, company_id)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    params
  end

  def get_job_position_invalid_params(user_id, company_id, invalid_state)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    params['state'] = invalid_state
    params
  end

  def get_job_position_matcher(user_id, company_id, job_position_id)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    params['user_id'] = user_id
    params['id'] = job_position_id
    params
  end

  def self.seed_get_job_position_params(user_id, company_id)
    params = @@job_position_params.clone
    params['user_id'] = user_id
    params['company_id'] = company_id
    params
  end

  # <----------- LeadEmail ---------------->

  @@lead_email_params = {
    "email" => "example@example.com", 
    "subject" => "1st Software Engineer Position",
    "email_body" => "Hello, I am contacting you regarding to the front end position", 
    "sent" => false, 
    "open" => false,
    "lead_id" => nil,
    "job_position_id" => nil
  }

  def create_lead_email(lead_id, job_position_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    LeadEmail.create(params)
  end

  def get_lead_email_params(lead_id, job_position_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    params
  end

  def get_lead_email_invalid_params(lead_id, job_position_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    params["email"] = "example@examplecom" 
    params
  end

  def get_lead_email_matcher(lead_id, job_position_id, lead_email_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    params['id'] = lead_email_id
    params
  end

  def lead_email_check_default_value(get_params, value)
    params = get_params.except!(value)
    LeadEmail.create(params)
  end

  def self.seed_get_lead_email_params(lead_id, job_position_id)
    params = @@lead_email_params.clone
    params['lead_id'] = lead_id
    params['job_position_id'] = job_position_id
    params
  end

end
