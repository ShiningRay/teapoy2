# encoding: utf-8
module UsersHelper

  #
  # Use this to wrap view elements that the user can't access.
  # !! Note: this is an *interface*, not *security* feature !!
  # You need to do all access control at the controller level.
  #
  # Example:
  # <%= if_authorized?(:index,   User)  do link_to('List all users', users_path) end %> |
  # <%= if_authorized?(:edit,    @user) do link_to('Edit this user', edit_user_path) end %> |
  # <%= if_authorized?(:destroy, @user) do link_to 'Destroy', @user, :confirm => 'Are you sure?', :method => :delete end %>
  #
  #
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  #
  # Link to user's page ('users/1')
  #
  # By default, their login is used as link text and link title (tooltip)
  #
  # Takes options
  # * :content_text => 'Content text in place of user.login', escaped with
  #   the standard h() function.
  # * :content_method => :user_instance_method_to_call_for_content_text
  # * :title_method => :user_instance_method_to_call_for_title_attribute
  # * as well as link_to()'s standard options
  #
  # Examples:
  #   link_to_user @user
  #   # => <a href="/users/3" title="barmy">barmy</a>
  #
  #   # if you've added a .name attribute:
  #  content_tag :span, :class => :vcard do
  #    (link_to_user user, :class => 'fn n', :title_method => :login, :content_method => :name) +
  #          ': ' + (content_tag :span, user.email, :class => 'email')
  #   end
  #   # => <span class="vcard"><a href="/users/3" title="barmy" class="fn n">Cyril Fotheringay-Phipps</a>: <span class="email">barmy@blandings.com</span></span>
  #
  #   link_to_user @user, :content_text => 'Your user page'
  #   # => <a href="/users/3" title="barmy" class="nickname">Your user page</a>
  #
  def link_to_user(user, options={})
    raise "Invalid user" unless user
    options.reverse_merge! :content_method => :login, :title_method => :login, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= user.send(options.delete(:content_method))
    options[:title] ||= user.send(options.delete(:title_method))
    link_to h(content_text), user_path(user), options
  end

  #
  # Link to login page using remote ip address as link content
  #
  # The :title (and thus, tooltip) is set to the IP address
  #
  # Examples:
  #   link_to_login_with_IP
  #   # => <a href="/login" title="169.69.69.69">169.69.69.69</a>
  #
  #   link_to_login_with_IP :content_text => 'not signed in'
  #   # => <a href="/login" title="169.69.69.69">not signed in</a>
  #
  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, h(content_text), options
    else
      link_to h(content_text), login_path, options
    end
  end

  #
  # Link to the current user's page (using link_to_user) or to the login page
  # (using link_to_login_with_IP).
  #
  def link_to_current_user(options={})
    if current_user
      link_to_user current_user, options
    else
      content_text = options.delete(:content_text) || 'not signed in'
      # kill ignored options from link_to_user
      [:content_method, :title_method].each{|opt| options.delete(opt)}
      link_to_login_with_IP content_text, options
    end
  end

  def format_username(user, anonymous=false)
    if user.id != 0 && !anonymous
      unless user.name?
        "<span class=\"user #{user.roles.collect(&:name)}\">#{h user.login}</span>"
      else
        "<span class=\"user #{user.role_names}\">user.name (#{h user.login})</span>"
      end
    else
      '<strong>匿名人士</strong>'
    end
  end



  def avatar(user, anonymous=false)
    user ? (
      user.id != 0 && !anonymous ?  link_to(image_tag(user.avatar.url(:thumb)),user,:class=>'avatar') + link_to( h(user.login), user, :class => user.roles.collect(&:name)) : '<strong>匿名人士</strong>'
    ) :
      ('该用户已被删除')
  end

  def user_detail_for(user)
    if logged_in?
      friend_ship_path = current_user.following?(user) ? unfollow_user_path(user) : follow_user_path(user)
      text = current_user.following?(user) ? "取消关注" : "关注"
      unless user.name?
        link_to user.login, user, :title => "@#{user.login}",  :data => {:login => user.login},:class => 'user'
      else
        link_to user.name, user, :title => "@#{user.login}", :data => {:login => user.login},:class => 'user'
      end
    else
      unless user.name?
        link_to user.login, user, :title => "@#{user.login}",:class => 'user', :data => {:login => user.login}
      else
        link_to user.name, user, :title => "@#{user.login}", :class => 'user', :data => {:login => user.login}
      end
    end
  end

  def calendar_options_for_user(user)
     dates=[]
     first = user.articles.latest.only('created_at', 'top_post_id').first.created_at.to_date
     last = Date.today
     first_month = first.month
     first_year = first.year
     last_year = last.year
     last_month = last.month
     (first_year..last_year).each do |year|
        (1..12).each do |month|
          unless (Time.mktime(year,month) < Time.mktime(first_year,first_month) || Time.mktime(year,month) > Time.mktime(last_year,last_month))
            dates<<"#{year}-#{month}"
          end
        end
     end
     select_tag("select_date_for_user",options_for_select(dates),:id=>"select_date_for_user",:data=>{:login=>user.login},:include_blank => true)
  end
end

