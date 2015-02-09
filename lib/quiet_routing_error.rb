class QuietRoutingError
  def initialize(app)
    @app = app
  end

  def call(env)
    res = @app.call(env)
    if res[0] == 404 and env['PATH_INFO'] =~ %r{/system|/assets}
      # binding.pry
      return [200, {}, ['Assets Not Found']]
    end
    res
  end
end
