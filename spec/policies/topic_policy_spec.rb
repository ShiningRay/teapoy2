require 'rails_helper'
describe TopicPolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:admin) { create :admin }
  let(:author) { create :user }
  let(:public_topic) { create :topic, user: author, status: 'publish' }
  let(:pending_topic) { create :topic, user: author, status: 'pending' }

  permissions :update? do
    it 'does not allow guest access if topic is unpublished' do
      expect(subject).not_to permit(user, pending_topic)
    end

    it 'not grants access if post is published and user is an normal user' do
      expect(subject).not_to permit(user, public_topic)
    end

    it 'grants access if post is unpublished and user is an admin' do
      expect(subject).to permit(admin, pending_topic)
    end

    it 'grants access if post is unpublished and user is an author' do
      expect(subject).to permit(author, public_topic)
    end
  end
end
