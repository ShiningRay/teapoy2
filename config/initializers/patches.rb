Dir[Rails.root.join('vendor/patches/*.rb')].each do |f|
  $stderr << "loading patch '#{f}'\n"
  load f
end
Dir[Rails.root.join('vendor/patches/jruby/*.rb')].each{|f| load f} if RUBY_PLATFORM =~ /java/