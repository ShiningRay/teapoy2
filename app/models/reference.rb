class Reference < ActiveRecord::Base
  belongs_to :source, :class_name => 'Article'
  belongs_to :target, :class_name => 'Article'
end
