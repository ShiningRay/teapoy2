require 'uri'
require 'fileutils'

module AnonymousCache

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def caches_page_for_anonymous(*pages)
      #before_filter :check_cache_for_anonymous, :only => pages
      after_filter :cache_for_anonymous, :only => pages
    end
  end

  def check_cache_for_anonymous
    return unless perform_caching
    return if logged_in? or !request.get?
    @cache_path ||= anon_cache_path

    if content = Rails.cache.read(@cache_path, :raw => true)
#      send_file(path, :type => 'text/html;charset=utf-8', :disposition => 'inline')
      send_data(content,
        :type => 'text/html;charset=utf-8', :disposition => 'inline')
      return false
    end
  end

  def cache_for_anonymous
    return unless perform_caching
    return if logged_in?
    @cache_path ||=  anon_cache_path
    @expires_in ||= 1.hour
#    self.class.benchmark "Cached page for guest: #{path}" do
#      FileUtils.makedirs(File.dirname(path))
#      File.open(path, "wb+") { |f| f.write(response.body) }
      Rails.cache.write(@cache_path, response.body, :expires_in => @expires_in.to_i, :raw => true)
#    end
  end

  protected :check_cache_for_anonymous
  protected :cache_for_anonymous
  private
    def anon_cache_path()
      path = File.join(request.host, request.path)
      format = request.format.try(:to_sym).to_s
      path = "#{path}.#{format}" unless params[:format] == '' and format == 'html'
      q = request.query_string
      path = "#{path}?#{q}" unless q.empty?
      path = "#{path}\#xhr" if request.xhr?
      logger.debug(path)
      path
#      path = File.join(page_cache_directory, path1)
#      name = (path.empty? || path == "/") ? "/index" : URI.unescape(path.chomp('/'))
#      name << page_cache_extension
#      return name
    end
end
