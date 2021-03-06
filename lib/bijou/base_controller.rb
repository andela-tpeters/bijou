require "tilt/erubis"

module Bijou
  class BaseController
    attr_reader :request

    def initialize(env)
      @request = env
    end

    def params
      @request.params
    end

    def response(body, status = 200, header = { "content-type" => "text/html" })
      @response = Response.new(body, status, header).reply
    end

    def show_response
      @response
    end

    def render(*args)
      response(render_template(*args))
    end

    def redirect_to(url_path, status = 301)
      response([], status, "location" => url_path)
    end

    def render_template(name, locals = {})
      file = File.join PATH, "app", "views", "layouts", "application.html.erb"
      page = File.join PATH, "app", "views", controller, "#{name}.html.erb"
      template = Tilt::ErubisTemplate.new(file)
      template.render { Tilt::ErubisTemplate.new(page).render(self, locals) }
    end

    private

    def controller
      self.class.to_s.gsub("Controller", "").to_snake_case
    end
  end
end
