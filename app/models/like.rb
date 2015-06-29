class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :story, counter_cache: true, touch: true
  validates :user, :story, presence: true
end
