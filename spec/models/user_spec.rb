# -*- coding: utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  login                     :string(255)      not null
#  email                     :string(255)      not null
#  crypted_password          :string(255)      not null
#  salt                      :string(255)      not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  remember_token            :string(255)      default(""), not null
#  remember_token_expires_at :datetime
#  activated_at              :datetime
#  avatar_file_name          :string(255)
#  avatar_content_type       :string(255)
#  avatar_file_size          :integer
#  avatar_updated_at         :datetime
#  state                     :string(255)      default("passive")
#  deleted_at                :datetime
#  name                      :string(100)
#  persistence_token         :string(255)      not null
#  login_count               :integer          default(0)
#  current_login_at          :datetime
#  last_login_at             :datetime
#  last_request_at           :datetime
#  current_login_ip          :string(255)
#  last_login_ip             :string(255)
#  perishable_token          :string(255)      default(""), not null
#  avatar_fingerprint        :string(255)
#
# Indexes
#
#  email                            (email) UNIQUE
#  index_users_on_perishable_token  (perishable_token)
#  index_users_on_state             (state)
#  login                            (login) UNIQUE
#  remember_token                   (remember_token)
#

require 'rails_helper'

describe User do
  describe '.guest' do
    subject { User.guest }
    its(:login) { should == 'guest' }
    its(:email) { should == 'guest@bling0.com'}
    context 'already has a guest record' do
      before {
        create(:user, login: 'guest', name: 'Guest', email: 'guest@bling0.com')
      }
      its(:login) { should == 'guest' }
      its(:email) { should == 'guest@bling0.com'}
      its(:id) { should_not be_nil }
    end
  end

  describe '#rename'  do
    let(:new_name) { 'NewName' }
    context 'a user has credits' do
      let(:user) { create :rich_user }
      it 'renames to new_name' do

        expect{
          user.rename new_name
        }.to change{ user.name_logs.count }
        user.reload
        expect(user.name).to eq(new_name)
      end
    end
    context 'a user has no credits' do
      let(:user) { create :active_user }
      it 'raise error when renaming' do
        expect{
          user.rename new_name
        }.to raise_error(Balance::InsufficientFunds)
      end
    end
  end
end
