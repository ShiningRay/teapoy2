# -*- encoding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
require 'digest/md5'
module ApplicationHelper
  def absolute_attachment_url(attachment_name, attachment_style = :original)
    "#{request.protocol}#{request.host_with_port}#{attachment_name.url(attachment_style)}"
  end

  def append_page_to_title collection
    content_for :title, " - 第#{collection.current_page}页"  if collection.current_page > 1
  end

  def oneline(&block)
    haml_concat capture_haml(&block).gsub("\n", '').gsub('\\n', "\n")
  end

  def typicon(name)
    raw "<span class='typcn typcn-#{name}'></span>"
  end

  def join_oneline(*args)
    args = Array.wrap(args).flatten
    opt = args.extract_options!
    args.compact.collect{|i|i.chomp}.join(opt[:sep].to_s).html_safe
  end

  def title *args
    options = args.extract_options!
    options.reverse_merge! :separator => ' | ', :page_title => nil
    content_for :title, options[:page_title] unless options[:page_title].blank?
    content_for :title, args
    args.join(' ')
  end

  def page_title *args
    options = args.extract_options!
    options.reverse_merge! :separator => ' | ', :page_title => nil

    args += [@title, @view_flow.get( :title), '博聆网']
    content_tag :title, args.flatten.compact.join(options[:separator])
  end

  def meta_keywords
    tag :meta, :content => (Array(@keywords)+Array(@view_flow.get(:keywords))).flatten.join(','), :name => 'keywords'
  end

  def meta_description
    tag :meta, :content => [@description, @view_flow.get( :description)].join('. '), :name => 'description'
  end

  def render_to(name, partial_name, opts={})
    content_for(name, render(opts.merge(:partial => partial_name)))
  end

  def render_skeleton
    render :template => 'layouts/skeleton'
  end

  def submit_to(name, path,  params={})
    form_tag path, method: :post, class: 'submit_button_form' do
      params.each do |k, v|
        tag :input, type: 'hidden', name: k, vale: v
      end
      # tag :input, name: 'authenticity_token', type: 'hidden', value: form_authenticity_token
      tag :input, value: name, type: 'submit'
    end
  end

  def br
    raw '<br/>'
  end

  def hr char='-', count=8, before='', after='<br/>'
    [before, char * count, after].join('').html_safe
  end

  def  current_user?(user=nil)
    user ||= @user
    logged_in? && current_user == user
  end

  def fast_strip_tags(html)
    Nokogiri::HTML(html).text
  end

  def show_login
    content_tag(:div ,:style=>"display:none") do
      render :partial =>"application/login"
    end
  end
  def scoped_path(opt={})
    if opt[:limit]
      opt[:order] = "hottest/#{opt[:limit]}"
    else
      opt[:order] ||= ''
    end
    unless opt[:scope]
      if @user
        opt[:scope] = "users/#{@user.to_param}/articles"
        if @group
          opt[:scope] = "users/#{@user.to_param}/groups/#{@group.alias}/articles"
        end
      elsif @group
        opt[:scope] = @group.alias
      elsif @tag
        opt[:scope] = "tags/#{@tag}"
      elsif params[:group_id] == 'realall'
         opt[:scope] = 'realall'
      else
        opt[:scope] = 'all'
      end
    end

    "/#{opt[:scope]}/#{opt[:order]}"
  end


  def include_head
    render 'application/head'
  end

  def include_javascripts
    render 'javascripts'
  end

  def show_flash
    unless flash.empty?
      [:notice, :warning, :error].collect do |key|
        content_tag :div, flash[key], {:class => "flash #{key} flash_#{key}"}
      end.join.html_safe
    end
  end

  def widget(name, opts={})
    opts.reverse_merge!({:tag => :li, :class => 'widget', :separator => nil})
    content_tag(opts[:tag], :class => "#{opts[:class]} #{name}") do
      #begin
      concat(render :partial => "widgets/#{name}")
      #rescue
      #  $!.
      #end
      concat opts[:separator]
    end
  end

  def widgets(*names)
    content_tag(:ul) do
      names.each do |name|
        concat widget(name)
      end
      yield if block_given?
    end
  end

  if ::Rails.env == 'production'
    def production_partial p
      render :partial => p
    end
  else
    def production_partial p; end
  end

  def body_attributes(opt=nil)
    @body_attributes ||= {:class => body_class_names}
    return @body_attributes unless opt
    @body_attributes.reverse_merge!(opt)
  end

  def body_class_names
    today = Date.today
    [controller_name, "#{controller_name}-#{action_name}",
     logged_in? ? 'logged_in' : 'not_logged_in',
    "y#{today.year}", "m#{today.month}", "d#{today.day}"
    ]
  end
  # Turns all URLs and e-mail addresses into clickable links. The <tt>:link</tt> option
  # will limit what should be linked. You can add HTML attributes to the links using
  # <tt>:html</tt>. Possible values for <tt>:link</tt> are <tt>:all</tt> (default),
  # <tt>:email_addresses</tt>, and <tt>:urls</tt>. If a block is given, each URL and
  # e-mail address is yielded and the result is used as the link text. By default the
  # text given is sanitized, you can override this behaviour setting the
  # <tt>:sanitize</tt> option to false.
  #
  # ==== Examples
  #   auto_link("Go to http://www.rubyonrails.org and say hello to david@loudthinking.com")
  #   # => "Go to <a href=\"http://www.rubyonrails.org\">http://www.rubyonrails.org</a> and
  #   #     say hello to <a href=\"mailto:david@loudthinking.com\">david@loudthinking.com</a>"
  #
  #   auto_link("Visit http://www.loudthinking.com/ or e-mail david@loudthinking.com", :link => :urls)
  #   # => "Visit <a href=\"http://www.loudthinking.com/\">http://www.loudthinking.com/</a>
  #   #     or e-mail david@loudthinking.com"
  #
  #   auto_link("Visit http://www.loudthinking.com/ or e-mail david@loudthinking.com", :link => :email_addresses)
  #   # => "Visit http://www.loudthinking.com/ or e-mail <a href=\"mailto:david@loudthinking.com\">david@loudthinking.com</a>"
  #
  #   post_body = "Welcome to my new blog at http://www.myblog.com/.  Please e-mail me at me@email.com."
  #   auto_link(post_body, :html => { :target => '_blank' }) do |text|
  #     truncate(text, :length => 15)
  #   end
  #   # => "Welcome to my new blog at <a href=\"http://www.myblog.com/\" target=\"_blank\">http://www.m...</a>.
  #         Please e-mail me at <a href=\"mailto:me@email.com\">me@email.com</a>."
  #
  #
  # You can still use <tt>auto_link</tt> with the old API that accepts the
  # +link+ as its optional second parameter and the +html_options+ hash
  # as its optional third parameter:
  #   post_body = "Welcome to my new blog at http://www.myblog.com/. Please e-mail me at me@email.com."
  #   auto_link(post_body, :urls)
  #   # => "Welcome to my new blog at <a href=\"http://www.myblog.com/\">http://www.myblog.com</a>.
  #         Please e-mail me at me@email.com."
  #
  #   auto_link(post_body, :all, :target => "_blank")
  #   # => "Welcome to my new blog at <a href=\"http://www.myblog.com/\" target=\"_blank\">http://www.myblog.com</a>.
  #         Please e-mail me at <a href=\"mailto:me@email.com\">me@email.com</a>."
  def auto_link(text, *args, &block)#link = :all, html = {}, &block)
    return ''.html_safe if text.blank?

    options = args.size == 2 ? {} : args.extract_options! # this is necessary because the old auto_link API has a Hash as its last parameter
    unless args.empty?
      options[:link] = args[0] || :all
      options[:html] = args[1] || {}
    end
    options.reverse_merge!(:link => :all, :html => {})
    sanitize = (options[:sanitize] != false)
    text = conditional_sanitize(text, sanitize).to_str
    case options[:link].to_sym
      when :all             then conditional_html_safe(auto_link_email_addresses(auto_link_urls(text, options[:html], options, &block), options[:html], &block), sanitize)
      when :email_addresses then conditional_html_safe(auto_link_email_addresses(text, options[:html], &block), sanitize)
      when :urls            then conditional_html_safe(auto_link_urls(text, options[:html], options, &block), sanitize)
    end
  end

  private

    AUTO_LINK_RE = %r{
        (?: ([0-9A-Za-z+.:-]+:)// | www\. )
        [^\s<]+
      }x

    # regexps for determining context, used high-volume
    AUTO_LINK_CRE = [/<[^>]+$/, /^[^>]*>/, /<a\b.*?>/i, /<\/a>/i]

    AUTO_EMAIL_RE = /[\w.!#\$%+-]+@[\w-]+(?:\.[\w-]+)+/

    BRACKETS = { ']' => '[', ')' => '(', '}' => '{' }

    # Turns all urls into clickable links.  If a block is given, each url
    # is yielded and the result is used as the link text.
    def auto_link_urls(text, html_options = {}, options = {})
      link_attributes = html_options.stringify_keys
      text.gsub(AUTO_LINK_RE) do
        scheme, href = $1, $&
        punctuation = []

        if auto_linked?($`, $')
          # do not change string; URL is already linked
          href
        else
          # don't include trailing punctuation character as part of the URL
          while href.sub!(/[^\w\/-]$/, '')
            punctuation.push $&
            if opening = BRACKETS[punctuation.last] and href.scan(opening).size > href.scan(punctuation.last).size
              href << punctuation.pop
              break
            end
          end

          link_text = block_given?? yield(href) : href
          href = 'http://' + href unless scheme

          unless options[:sanitize] == false
            link_text = sanitize(link_text)
            href      = sanitize(href)
          end
          content_tag(:a, link_text, link_attributes.merge('href' => href,'target' => "_blank"), !!options[:sanitize]) + punctuation.reverse.join('')
        end
      end
    end

    # Turns all email addresses into clickable links.  If a block is given,
    # each email is yielded and the result is used as the link text.
    def auto_link_email_addresses(text, html_options = {}, options = {})
      text.gsub(AUTO_EMAIL_RE) do
        text = $&

        if auto_linked?($`, $')
          text.html_safe
        else
          display_text = (block_given?) ? yield(text) : text

          unless options[:sanitize] == false
            text         = sanitize(text)
            display_text = sanitize(display_text) unless text == display_text
          end
          mail_to text, display_text, html_options
        end
      end
    end

    # Detects already linked context or position in the middle of a tag
    def auto_linked?(left, right)
      (left =~ AUTO_LINK_CRE[0] and right =~ AUTO_LINK_CRE[1]) or
        (left.rindex(AUTO_LINK_CRE[2]) and $' !~ AUTO_LINK_CRE[3])
    end

    def conditional_sanitize(target, condition)
      condition ? sanitize(target) : target
    end

    def conditional_html_safe(target, condition)
      condition ? target.html_safe : target
    end
    def img_for_google_analysis
        params_for_analysis={}
	      params_for_analysis["utmn"] = rand(0x7fffffff)
	      params_for_analysis["utmr"] = request.headers['Referer']||'-'
	      params_for_analysis["utmhn"] = request.host
	      params_for_analysis["utmp"] = request.fullpath
	      params_for_analysis["utmac"] = 'MO-576087-7'
	      params_for_analysis["utmwv"] = "4.4sh"
        params_for_analysis["utmcc"] = '__utma=999.999.999.999.999.1;'
	      if request.remote_ip.blank?
	        params_for_analysis["utmip"] = ""
	       else
	        params_for_analysis["utmip"] = (request.remote_ip.split(".")[0,3]<< "0").join(".")
	      end
	      if cookies["__utmmobile"]
		      guid =  cookies["__utmmobile"]
	      else
	        guid = request.headers['HTTP_X_DCMGUID']	|| request.headers['HTTP_X_UP_SUBNO']	||  request.headers['HTTP_X_JPHONE_UID']	|| request.headers['HTTP_X_EM_UID']
	      end
        if guid
		      message = guid + params_for_analysis["utmac"]
	      else
		      message = rand(0x7fffffff).to_s
        end
	        cook = Digest::MD5.hexdigest(message)
		      cookies["__utmmobile"] = params_for_analysis["utmvid"] = "0x" +cook[0,16]
		      ppp=""
		      params_for_analysis.each_pair do |index , value |
		        ppp<<"#{index}=#{value}&"
		      end
       return   "http://www.google-analytics.com/__utm.gif?"+URI.encode(ppp)
    end
end
