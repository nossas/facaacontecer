require 'spec_helper'

describe MailWorker, worker: true do
  describe "#perform" do

    context " When the subscription's subscriber wasn't invited by another user" do
      let(:subscription) { Subscription.make! }

      it "delivers an email" do
        expect {
          MailWorker.new.perform(subscription.id)
        }.to change{ ActionMailer::Base.deliveries.size }.by(1)
      end
    end

    context " When the subscription's subscriber was invited by another user" do
      let(:subscriber)   { User.make!(cpf: CPF.generate) }
      let(:invite)       { Invite.make!(parent_user_id: subscriber.id) }
      let(:subscription) { Subscription.make!(subscriber: invite.user) }

      it "delivers two emails" do
        expect {
          MailWorker.new.perform(subscription.id)
        }.to change{ ActionMailer::Base.deliveries.size }.by(2)
      end
    end
  end
end

