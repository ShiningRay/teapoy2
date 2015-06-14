# == Schema Information
#
# Table name: references
#
#  id            :integer          not null, primary key
#  source_id     :integer
#  target_id     :integer
#  relation_type :string(255)
#  detected      :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Reference < ActiveRecord::Base
  belongs_to :source, :class_name => 'Article'
  belongs_to :target, :class_name => 'Article'
end
