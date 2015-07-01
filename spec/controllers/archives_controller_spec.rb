require 'rails_helper'

describe ArchivesController do
  let(:group){ create :group }

  it 'GET index' do
    get :index, group_id: group.alias
    # expect(response).to be_success
  end

  describe 'GET show' do
    let!(:topic) { create :topic, group: group, created_at: Time.local(2013, 4, 5, 12, 0, 0) }

    it 'gets year index' do

      get :show, group_id: group.alias, id: '2013'
      # expect(assigns(:topics)).to include(topic)
    end

    it 'gets monthly index' do
      get :show, group_id: group.alias, id: '2013-04'
      expect(assigns(:topics)).to include(topic)
    end

    it 'gets daily index' do
      get :show, group_id: group.alias, id: '2013-04-05'
      expect(assigns(:topics)).to include(topic)
    end
  end
end
