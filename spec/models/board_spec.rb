require "rails_helper"

RSpec.describe Board, type: :model do
  let(:user) { create(:user) }
  subject { build(:board, user_id: user.id) }

  describe "Validations" do
    context "when a board instance is initialized" do
      it "passes all the validations" do
        expect(subject).to be_valid
      end
    end

    describe "name" do
      it "must be presence" do
        subject.name = nil

        expect(subject).to_not be_valid
      end

      it "must be maxium 20 characters" do
        subject.name = "ferba bdks dhd nd snd derder"

        expect(subject).to_not be_valid
      end

      it "must be minimun 2 characters" do
        subject.name = "a"

        expect(subject).to_not be_valid
      end

      it "must be only letters and white spaces" do
        subject.name = "this # % 323"

        expect(subject).to_not be_valid
      end
    end

    describe "user_id" do
      it "must be presence" do
        subject.user_id = nil

        expect(subject).to_not be_valid
      end

      it "must exist on the DB" do
        subject.user_id = subject.user_id + 1

        expect(subject).to_not be_valid
      end
    end
  end
end
