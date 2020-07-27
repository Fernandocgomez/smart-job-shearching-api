require "rails_helper"

RSpec.describe LeadEmail, type: :model do
  before(:each) do
    @user = create_user
    @company = create_company
    @board = create_board(@user.id)
    @column = create_column(@board.id)
    @lead = create_lead(@column.id, @company.id)
    @job_position = create_job_position(@user.id, @company.id)
    @lead_email_params = get_lead_email_params(@lead.id, @job_position.id)
  end

  subject {
    # This create an instance of the LeadEmail model
    # requests_helper.rb
    create_lead_email(@lead.id, @job_position.id)
  }

  describe "validations" do
    describe "email" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.email = nil
        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = lead_email_check_default_value(@lead_email_params, "email")
        expect(lead_email).to be_valid
        expect(lead_email["email"]).to eq("example@example.com")
      end
      it "must be a valid email format" do
        expect(subject).to be_valid
        subject.email = "fernando@wrongformatcom"
        expect(subject).to_not be_valid
      end
    end
    describe "subject" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.subject = nil
        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = lead_email_check_default_value(@lead_email_params, "subject")
        expect(lead_email).to be_valid
        expect(lead_email["subject"]).to eq("write an eye catching email subject")
      end
      it "must have a minimum length of 15 characters" do
        expect(subject).to be_valid
        subject.subject = "short subject"
        expect(subject).to_not be_valid
      end
      it "must have a maximum length of 70 characters" do
        expect(subject).to be_valid
        subject.subject = "this is a very very very long subject that will not have a good open rate"
        expect(subject).to_not be_valid
      end
      it "must have contains only letters, spaces and numbers " do
        expect(subject).to be_valid
        subject.subject = "Hello Dear # person %"
        expect(subject).to_not be_valid
      end
    end
    describe "email_body" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.email_body = nil
        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = lead_email_check_default_value(@lead_email_params, "email_body")
        expect(lead_email).to be_valid
        expect(lead_email["email_body"]).to eq("compost an email...")
      end
    end
    describe "sent" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.sent = nil
        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = lead_email_check_default_value(@lead_email_params, "sent")
        expect(lead_email).to be_valid
        expect(lead_email["sent"]).to be(false)
      end
    end
    describe "open" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.open = nil
        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = lead_email_check_default_value(@lead_email_params, "open")
        expect(lead_email).to be_valid
        expect(lead_email["open"]).to be(false)
      end
    end
    describe "lead_id" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.lead_id = nil
        expect(subject).to_not be_valid
      end
      it "must exist on the DB" do
        expect(subject).to be_valid
        subject.lead_id = subject.lead_id + 1
        expect(subject).to_not be_valid
      end
    end
    describe "job_position_id" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.job_position_id = nil
        expect(subject).to_not be_valid
      end
      it "must exist on the DB" do
        expect(subject).to be_valid
        subject.job_position_id = subject.job_position_id + 1
        expect(subject).to_not be_valid
      end
    end
  end
end
