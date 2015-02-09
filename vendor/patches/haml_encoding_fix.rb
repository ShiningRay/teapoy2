
class Haml::Buffer
	def push_text_with_force_encoding(text, tab_change, dont_tab_up)
		push_text_without_force_encoding(text.encoding == Encoding::ASCII_8BIT ? text.force_encoding(Encoding.find(options[:encoding])) : text, tab_change, dont_tab_up)
	end
	alias_method_chain :push_text, :force_encoding
end
