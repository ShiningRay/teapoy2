# coding: utf-8
#require 'rack/multipart'
Rack::Multipart::Parser.class_eval do
	alias original_setup_parse setup_parse
	def setup_parse
	  original_setup_parse and ( @content_length.to_i > 0 )
	end
end
