module JqueryMobileHelper
	def jqm_page

	end
  def jqm_header(options={}, &block)
    content_tag(:div, options.reverse_merge('data-role' => 'header', 'data-position' => 'fixed', 'data-fullscreen'=>"false",  'data-tap-toggle'=>"false"), false, &block)
  end
  def jqm_menu_link
    link_to '菜单', '#leftpanel', data: {icon: 'bars', iconpos: 'notext'}
  end
  def jqm_back_link_to(href, content='返回', options={})
    if content.is_a?(Hash)
      options = content
      content = '返回'
    end

    link_to content, href, options.reverse_merge('data-icon' => 'carat-l', 'data-rel' => 'back', 'data-direction' => 'reverse', 'data-iconpos' => 'notext')
  end
end
