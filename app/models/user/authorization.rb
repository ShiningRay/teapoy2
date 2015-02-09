# coding: utf-8
module User::Authorization
  extend ActiveSupport::Concern

  included do
    include ::AASM
    aasm column: :state do
      state :pending, initial: true, enter: :reset_perishable_token
      state :passive
      state :active,  enter: :do_activate
      state :suspended
      state :deleted, enter: :do_delete

      event :register do
        transitions from: :passive, to: :pending, guard: -> (u) { !(u.crypted_password.blank? && u.password.blank?) }
      end

      event :activate do
        transitions from: :pending, to: :active
      end

      event :suspend do
        transitions from: [:passive, :pending, :active], to: :suspended
      end

      event :delete do
        transitions from: [:passive, :pending, :active, :suspended], to: :deleted
      end

      event :unsuspend do
        transitions from: :suspended, to: :active,  guard: -> (u) { !u.activated_at.blank? }
        transitions from: :suspended, to: :pending, guard: -> (u) { !u.perishable_code.blank? }
        transitions from: :suspended, to: :passive
      end
    end
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def do_delete
    self.deleted_at = Time.now.utc
    articles.destroy_all
    posts.destroy_all
  end

  def do_activate
    @activated = true
    self.activated_at = Time.now.utc
    self.deleted_at = nil
  end
end
