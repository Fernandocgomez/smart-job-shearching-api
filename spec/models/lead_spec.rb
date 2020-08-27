require "rails_helper"

RSpec.describe Lead, type: :model do
  let(:user) { create(:user) }
  let(:company) { create(:company, user_id: user.id) }
  let(:board) { create(:board, user_id: user.id) }
  let(:column) { create(:column, board_id: board.id) }
  subject { build(:lead, column_id: column.id, company_id: company.id) }

  describe "Validations" do
    context "when a lead instance is initialized" do
      it "passes all the validations" do
        expect(subject).to be_valid
      end
    end

    describe "first_name" do
      it "must be presence" do
        subject.first_name = nil

        expect(subject).to_not be_valid
      end
      it "must be only letters(upper case and lower case)" do
        subject.first_name = "Fernando 32%"

        expect(subject).to_not be_valid
      end
      it "must be at least 2 characters long" do
        subject.first_name = "F"

        expect(subject).to_not be_valid
      end
      it "must be maximum of 15 characters long" do
        subject.first_name = "fernandocgomezferferfer"

        expect(subject).to_not be_valid
      end
    end

    describe "last_name" do
      it "must be presence" do
        subject.last_name = nil

        expect(subject).to_not be_valid
      end
      it "must be only letters(upper case and lower case)" do
        subject.last_name = "Gomez 32%"

        expect(subject).to_not be_valid
      end
      it "must be at least 2 characters long" do
        subject.last_name = "G"
        expect(subject).to_not be_valid
      end
      it "must be maximum of 15 characters long" do
        subject.last_name = "fernandocgomezferferfer"

        expect(subject).to_not be_valid
      end
    end

    describe "picture_url" do
      it "must be presence" do
        subject.picture_url = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead = init_lead_instance_with_default_value(column.id, company.id, "picture_url")

        expect(lead).to be_valid
        expect(lead["picture_url"]).to eq("https://mail.achieverspoint.com/img/default-avatar.jpg")
      end
    end

    describe "linkedin_url" do
      it "must be presence" do
        subject.linkedin_url = nil

        expect(subject).to_not be_valid
      end
    end

    describe "status" do
      it "must be presence" do
        subject.status = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead = init_lead_instance_with_default_value(column.id, company.id, "status")

        expect(lead).to be_valid
        expect(lead["status"]).to eq("new")
      end
    end

    describe "notes" do
      it "must be presence" do
        subject.notes = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead = init_lead_instance_with_default_value(column.id, company.id, "notes")

        expect(lead).to be_valid
        expect(lead["notes"]).to eq("write a note...")
      end
    end

    describe "email" do
      it "must be optional" do
        subject.email = ""

        expect(subject).to be_valid
      end
    end

    describe "phone_number" do
      it "must be presence" do
        subject.phone_number = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        lead = init_lead_instance_with_default_value(column.id, company.id, "phone_number")

        expect(lead).to be_valid
        expect(lead["phone_number"]).to eq("3462600832")
      end
      it "must be a valid US phone number" do
        subject.phone_number = "346260083"

        expect(subject).to_not be_valid
      end
    end

    describe "column_id" do
      it "must be presence" do
        subject.column_id = nil

        expect(subject).to_not be_valid
      end
      it "must exist on the DB" do
        subject.column_id = subject.column_id + 1

        expect(subject).to_not be_valid
      end
    end

    describe "company_id" do
      it "must be presence" do
        subject.company_id = nil

        expect(subject).to_not be_valid
      end
      it "must exist on the DB" do
        subject.company_id = subject.company_id + 1

        expect(subject).to_not be_valid
      end
    end

  end
end
