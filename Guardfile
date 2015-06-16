# More info at https://github.com/guard/guard#readme
guard :bundler do
  watch('Gemfile')
end

# -f html -o ./tmp/spec_results.html
guard 'rspec', cmd: 'spring rspec -f doc --color',
    #launchy: './tmp/spec_results.html',
    :all_after_pass => true  ,
    :all_on_start => true    do
  watch(%r{^spec/.+?_spec\.rb$})
  watch(%r{^lib/(.+?)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')                       { "spec" }
  watch('spec/rails_helper.rb')                       { "spec" }

  # Rails example
  watch('spec/spec_helper.rb')                       { "spec" }
  watch('config/routes.rb')                          { "spec/routing" }
  watch('app/controllers/application_controller.rb') { "spec/controllers" }
  watch(%r{^app/(.+)\.rb})                           { |m| ["spec/#{m[1]}_spec.rb",
   "spec/#{File.dirname(m[1])}_spec.rb" ]}
  watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  do |m|
    ["spec/routing/#{m[1]}_routing_spec.rb",
     "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
     "spec/acceptance/#{m[1]}_spec.rb"]
  end
end

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
end

# guard :rubocop, all_on_start: false, cli: ['--format', 'clang', '--rails'] do
#   watch(%r{.+\.rb$})
#   watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
# end
