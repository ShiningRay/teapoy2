# coding: utf-8

require 'rails_helper'

describe GroupsController do
  let(:group) { create :group }

  it 'GET index' do
    get :index
  end

  it 'GET show' do
    get :show, id: group.alias
  end

  describe 'GET search' do
    it 'finds related groups' do
      get :search, search: 'test'
      expect(assigns(:groups)).to be_blank
    end
  end
end
