# encoding: utf-8
#require "application_responder"
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #self.responder = ApplicationResponder
  etag { $revision }

  include Pundit

  respond_to :html, :js, :json, :mobile, :wml
  protect_from_forgery
  include AuthenticatedSystem
  include AnonymousCache
  # include PostLock
  include MobileSystem
  # include SeoMethods
  #include AuthorizedSystem
  #include SuperCache
  #check_authorization
  rescue_from ActionController::UnknownFormat, with: :show_404

  def render *args
    #set_theme(params[:theme] || cookies[:theme] || @group.try(:theme))
    # logger.debug [@theme, cookies[:theme], @group.try(:theme)].join(' ')

    set_theme(@theme || cookies[:theme] || @group.try(:theme))
    super
  end

  protected

  def default_url_options(opts={})
    if request.format == :wml and logged_in? and request.session_options[:id]
      opts.merge!({(request.session_options[:key] || '_session_id') => request.session_options[:id]})
    end
    opts
  end

  def render_feed options = {}
    @options = options
    render :template => "common/rss.xml.builder", :layout => false, :content_type => 'text/xml'
  end
  # Handle public-facing errors by rendering the "error" liquid template
  def show_404 target=''
    show_error "Page \"#{target}\" Not Found", :not_found
  end

  def show_notice(content)
    @notice = content
    render :template => 'common/notice', :layout => false
  end

  def show_error(message = 'An error occurred.', status = :internal_server_error)
    @message = message
    render :template => 'common/error', :status => status, :layout => false
  end

  def inspect_object(object)
    case object
    when Hash, Array
      object.inspect
    when ActionController::Base
      "#{object.controller_name}##{object.action_name}"
    else
      object.to_s
    end
  end

  def cache_key_for_current_user(name)
    if logged_in?
      case name
      when Hash
        name.merge(:current_user => current_user.to_param, :format => request.format.to_sym)
      when Array
        name.unshift(current_user.to_param)
        name << request.format.to_sym
      when String
        name += "#{current_user.to_param}.#{request.format.to_sym}"
      end
    end
    name
  end

  helper_method :cache_key_for_current_user

  def check_domain
    if g = Group.find_by_domain(request.domain)
      @group = g
    end
  end
  before_filter :check_domain

  after_filter :set_access_control_headers
  def set_access_control_headers
    # logger.debug(request.headers.inspect)
    headers['Access-Control-Allow-Origin'] = request.headers['Origin'] || '*'
    headers['Access-Control-Request-Method'] = 'GET, POST, OPTIONS'
  end


  def find_user
    @user ||= User.find_by_login!(params[:user_id])
  end


  def group
    @group ||= Group.find_by_alias(params[:group_id])
  end
  alias find_group group

  def topic_path(*args)
    group_topic_path(*args)
  end

  def topics_path(*args)
    group_topics_path(*args)
  end

  def new_topic_path(*args)
    new_group_topic_path(*args)
  end

  helper_method :topic_path, :topics_path, :new_topic_path
  def default_serializer_options
    {
      root: false
    }
  end

  def set_flash(type, object: nil)
    flash[:from] = action_name
    flash[:type] = type
    flash[:object_type] = object.class.name
    flash[:object_id]   = object.id
  end
end
