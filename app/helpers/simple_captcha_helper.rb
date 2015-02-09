# coding: utf-8
module SimpleCaptchaHelper
    def show_simple_captcha_for_wml(options={})
      key = simple_captcha_key(options[:object])
      options[:field_value] = set_simple_captcha_data(key, options)

      defaults = {
         :image => simple_captcha_image(key, options),
         :label => options[:label] || I18n.t('simple_captcha.label'),
         :field => simple_captcha_field(options)
         }

      render :partial => 'simple_captcha/simple_captcha', :locals => { :simple_captcha_options => defaults }
    end

    private
      def simple_captcha_image(simple_captcha_key, options = {})
        defaults = {}
        defaults[:time] = options[:time] || Time.now.to_i

        query = defaults.collect{ |key, value| "#{key}=#{value}" }.join('&')
        url = "/simple_captcha?code=#{simple_captcha_key}&amp;#{query}"

        "<img src='#{url}' alt='captcha' />".html_safe
      end
end