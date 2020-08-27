require "rails_helper"

RSpec.describe JobPosition, type: :model do
  
  let(:user) { create(:user) }
  let(:company) { create(:company, user_id: user.id) }
  subject { build(:job_position, company_id: company.id) }

  describe "validations" do
    context "when a lead instance is initialized" do
      it "passes all the validations" do
        expect(subject).to be_valid
      end
    end

    describe "name" do
      it "must be presence" do
        subject.name = nil

        expect(subject).to_not be_valid
      end
    end
    
    describe "description" do
      it "must be presence" do
        subject.description = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        job_position = init_job_position_instance_with_default_value(company.id, "description")

        expect(job_position).to be_valid
        expect(job_position["description"]).to eql("job description should be here")
      end
      it 'must not contain a single double quotes (")' do
        # I am not sure about this validation
      end
    end
    
    describe "city" do
      it "must be presence" do
        subject.city = nil

        expect(subject).to_not be_valid
      end
    end
    
    describe "state" do
      it "must be presence" do
        subject.state = nil

        expect(subject).to_not be_valid
      end
      it "must be 2 characters" do
        subject.state = "TXX"

        expect(subject).to_not be_valid
      end
      it "must be uppercase" do
        subject.state = "TX"

        expect(subject).to be_valid
      end
      it 'must be lowercase' do
        subject.state = "tx"

        expect(subject).to be_valid
      end
      
    end
    
    describe "applied" do
      it "must be presence" do
        subject.applied = nil

        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        job_position = init_job_position_instance_with_default_value(company.id, "applied")

        expect(job_position).to be_valid
        expect(job_position["applied"]).to be(false)
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
