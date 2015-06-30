module GuestbooksHelper
  def guestbook
    @decorated_guestbook ||= @guestbook.decorate
  end
end
