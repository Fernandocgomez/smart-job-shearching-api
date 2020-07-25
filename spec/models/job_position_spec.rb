require "rails_helper"

RSpec.describe JobPosition, type: :model do
  before(:each) do
    @user = create_user
    @company = create_company
  end

  subject {
    # This create an instance of the JobPosition model
    # requests_helper.rb
    create_job_position(@user.id, @company.id)
  }

  describe "validations" do
    describe "name" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.name = nil
        expect(subject).to_not be_valid
      end
    end
    describe "description" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.description = nil
        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        params = get_job_position_params(@user.id, @company.id)
        params.except!("description")
        job_position = JobPosition.create(params)
        expect(job_position).to be_valid
        expect(job_position["description"]).to eql("job description should be here")
      end
      it 'must not contain a single double quotes (")' do
        # I am not sure about this validation
      end
    end
    describe "city" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.city = nil
        expect(subject).to_not be_valid
      end
    end
    describe "state" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.state = nil
        expect(subject).to_not be_valid
      end
      it "must be 2 characters" do
        expect(subject).to be_valid
        subject.state = "T"
        expect(subject).to_not be_valid
        subject.state = "TXX"
        expect(subject).to_not be_valid
      end
      it "must be uppercase or lowercase " do
        expect(subject).to be_valid
        subject.state = "T2"
        expect(subject).to_not be_valid
        subject.state = "T "
        expect(subject).to_not be_valid
      end
    end
    describe "applied" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.applied = nil
        expect(subject).to_not be_valid
      end
      it "must have a default value" do
        params = get_job_position_params(@user.id, @company.id)
        params.except!("applied")
        job_position = JobPosition.create(params)
        expect(job_position).to be_valid
        expect(job_position["applied"]).to be(false)
      end
    end
    describe "user_id" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.user_id = nil
        expect(subject).to_not be_valid
      end
      it "must exist on the DB" do
        expect(subject).to be_valid
        subject.user_id = subject.user_id + 1
        expect(subject).to_not be_valid
      end
    end
    describe "company_id" do
      it "must be presence" do
        expect(subject).to be_valid
        subject.company_id = nil
        expect(subject).to_not be_valid
      end
      it "must exist on the DB" do
        expect(subject).to be_valid
        subject.company_id = subject.company_id + 1
        expect(subject).to_not be_valid
      end
    end
  end
end
