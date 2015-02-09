# coding: utf-8

module Article::States
  def self.included(base)
    #STATUSES = [:public, :private, :pending, :spam, :deleted]
    base.class_eval do
      include AASM
      aasm_column :status
      aasm_initial_state :initial => :pending
      aasm_state :private
      aasm_state :pending
      aasm_state :public, :enter => :do_publish, :exit => :do_unpublish
      aasm_state :deleted, :enter => :do_delete

      aasm_event :publish do
        transitions :from => [:private, :pending], :to => :public
      end

      aasm_event :reject do
        transitions :from => [:public, :pending], :to => :private
      end

      aasm_event :delete do
        transitions :from => [:public, :private, :pending], :to => :deleted
      end
      after_save do
        _create_score if @to_create_score
        @to_create_score = false
      end
      after_save do
        score.destroy if @to_destroy_score
        @to_destroy_score = false
      end
    end
  end
  def do_publish
    @to_create_score = true
  end
  def do_unpublish
    @to_destroy_score = true
  end
  def do_delete
  end
end
