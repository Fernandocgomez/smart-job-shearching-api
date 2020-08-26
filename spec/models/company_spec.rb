require "rails_helper"

RSpec.describe Company, type: :model do
  
  let(:user) { create(:user) }
  subject { build(:company, user_id: user.id) }

  describe "Validations" do
    context "when a company instance is initialized" do
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

    describe "linkedin_url" do
      it "must be presence" do
        subject.linkedin_url = nil

        expect(subject).to_not be_valid
      end
    end

    describe "website" do
      it "must have a default value" do
        company = init_company_instance_with_default_value(user.id, "website")

        expect(company).to be_valid
        expect(company["website"]).to eql("wwww.companyxwy.com")
      end
    end

    describe "about" do
      it "must have a default value" do
        company = init_company_instance_with_default_value(user.id, "about")

        expect(company).to be_valid
        expect(company["about"]).to eql("about the company")
      end
    end

    describe 'user_id' do
      it 'must be presence' do
        subject.user_id = nil

        expect(subject).to_not be_valid
      end
    end
    
  end
end
