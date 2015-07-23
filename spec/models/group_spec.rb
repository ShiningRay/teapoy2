# coding: utf-8
# == Schema Information
#
# Table name: groups
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  description       :string(255)
#  created_at        :datetime
#  alias             :string(255)
#  options           :text(65535)
#  owner_id          :integer
#  icon_file_name    :string(255)
#  icon_content_type :string(255)
#  icon_file_size    :integer
#  icon_updated_at   :datetime
#  private           :boolean          default(FALSE)
#  feature           :integer          default(0), not null
#  theme             :string(255)
#  status            :string(255)      default("open"), not null
#  score             :integer          default(0), not null
#  hide              :boolean          default(FALSE), not null
#  domain            :string(255)
#
# Indexes
#
#  index_groups_on_alias   (alias) UNIQUE
#  index_groups_on_domain  (domain) UNIQUE
#  index_groups_on_hide    (hide)
#

require 'rails_helper'

describe Group do
  subject(:group) { create :group }

  describe '.search' do
    it 'returns which name contains keywords' do
      group = create :group, name: 'test'
      expect(Group.search('test')).to match([group])
    end
  end
end
