require "rails_helper"

RSpec.describe LeadEmail, type: :model do
  let(:user) { create(:user) }
  let(:company) { create(:company, user_id: user.id) }
  let(:board) { create(:board, user_id: user.id) }
  let(:column) { create(:column, board_id: board.id) }
  let(:lead) { create(:lead, column_id: column.id, company_id: company.id) }
  let(:job_position) { create(:job_position, company_id: company.id) }
  subject { build(:lead_email, lead_id: lead.id, job_position_id: job_position.id) }

  describe "validations" do
    context "when a lead_email instance is initialized" do
      it "passes all the validations" do
        expect(subject).to be_valid
      end
    end

    describe "email" do
      it "must be presence" do
        subject.email = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = init_lead_email_instance_with_default_value(lead.id, job_position.id, "email")

        expect(lead_email).to be_valid
        expect(lead_email["email"]).to eq("example@example.com")
      end
      it "must be a valid email format" do
        subject.email = "fernando@wrongformatcom"

        expect(subject).to_not be_valid
      end
    end
    describe "subject" do
      it "must be presence" do
        subject.subject = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = init_lead_email_instance_with_default_value(lead.id, job_position.id, "subject")

        expect(lead_email).to be_valid
        expect(lead_email["subject"]).to eq("write an eye catching email subject")
      end
      it "must have a minimum length of 15 characters" do
        subject.subject = "short subject"

        expect(subject).to_not be_valid
      end
      it "must have a maximum length of 70 characters" do
        subject.subject = "this is a very very very long subject that will not have a good open rate"

        expect(subject).to_not be_valid
      end
      it "must have contains only letters, spaces and numbers " do
        subject.subject = "Hello Dear # person %"

        expect(subject).to_not be_valid
      end
    end
    describe "email_body" do
      it "must be presence" do
        subject.email_body = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = lead_email = init_lead_email_instance_with_default_value(lead.id, job_position.id, "email_body")

        expect(lead_email).to be_valid
        expect(lead_email["email_body"]).to eq("compost an email...")
      end
    end
    describe "sent" do
      it "must be presence" do
        subject.sent = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = lead_email = init_lead_email_instance_with_default_value(lead.id, job_position.id, "sent")

        expect(lead_email).to be_valid
        expect(lead_email["sent"]).to be(false)
      end
    end
    describe "open" do
      it "must be presence" do
        subject.open = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead_email = lead_email = init_lead_email_instance_with_default_value(lead.id, job_position.id, "open")

        expect(lead_email).to be_valid
        expect(lead_email["open"]).to be(false)
      end
    end
    describe "lead_id" do
      it "must be presence" do
        subject.lead_id = nil

        expect(subject).to_not be_valid
      end
      it "must exist on the DB" do
        subject.lead_id = subject.lead_id + 1

        expect(subject).to_not be_valid
      end
    end
    describe "job_position_id" do
      it "must be presence" do
        subject.job_position_id = nil

        expect(subject).to_not be_valid
      end
      it "must exist on the DB" do
        subject.job_position_id = subject.job_position_id + 1
        
        expect(subject).to_not be_valid
      end
    end
  end
end
