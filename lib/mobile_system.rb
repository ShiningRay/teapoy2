# coding: utf-8
module MobileSystem
  def self.included(base)
    base.before_filter :set_mobile_format_according_to_domain
  end

  def set_mobile_format_according_to_domain
    if params.include?(:wap)
      request.format = :wml
    elsif params.include?(:mobile)
      if params[:mobile] == 'false'
        cookies.delete(:mobile_view)
      else
        cookies[:mobile_view] = 'mobile'
      end
    end
    if cookies[:mobile_view] == 'mobile'
      self.theme_name = 'mobile'
    end
    case request.host
    when 'm.bling0.com'
      # request.variant = :mobile if browser.mobile?
      self.theme_name = 'mobile'
      @default_host = 'm.bling0.com'
      Rails.logger.info self.theme_name
    when 'wap.bling0.com'
      @default_host = 'wap.bling0.com'
      request.format = :wml
      #fix some strange double-encoded brackets
    when 'j.bling0.com'
      self.theme_name = 'jquerymobile'
    else
      if browser.mobile?
        request.variant = :phone
        self.theme_name = 'jquerymobile'
      end
    end
    Rails.logger.info self.theme_name
    select_font if cookies[:mobile_view] == 'mobile'
    decode_brackets if browser.mobile?
  end

  def select_font
    if params[:fontsize] and ['small', 'normal', 'large'].include?(params[:fontsize])
      cookies[:fontsize] = {:value => params[:fontsize], :expires => 20.years.from_now.utc}
    end
    if params[:pic] and %w(show hide).include?(params[:pic])
      cookies[:pic] = {:value => params[:pic], :expires => 20.years.from_now.utc}
    end
  end

  def transform_binary(hash, key)
    p = hash[key]
    return unless p.is_a?(String)
    f = Tempfile.new(['mobile', '.jpg'])
    f.binmode
    f.write p
    hash[key] = f
  end

  def decode_brackets
    if request.post?
      unless params['wml_set_var_name'].blank?
        name, value = params['wml_set_var_name'].split(',', 2)
        unless name =~ /\[/
          name = "#{controller_name.singularize}[#{name}]"
        end
        params[name] = value
      end
      params.each_pair do |k, v|
        if k =~ /(\w+)(?:%5b|\[)(\w+)(?:%5d|\])/i
          params[$1] ||= HashWithIndifferentAccess.new
          params[$1][$2] = v
        end
      end
    end
  end
  protected :set_mobile_format_according_to_domain, :select_font, :decode_brackets
end
