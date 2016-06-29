require "active_params/version"
require "active_params/parser"
require "active_params/controller"

module ActiveParams
  class << self
    attr_accessor :writing, :path, :scope

    # ActiveParams.config {|c| .... }
    def config
      yield self
    end

    # `include ActiveParams` use default settings
    def included(base)
      base.send(:include, setup)
    end

    # `include ActiveParams.setup({...})` customize
    def setup(options = {})
      Module.new do
        def self.included(base)
          base.send(:include, ActiveParams::Controller)
        end
      end.tap do |m|
        m.send(:define_method, :active_params_options) { options }
      end
    end
  end
end

ActiveParams.config do |config|
  config.writing = defined?(Rails) && Rails.env.development?
  config.path    = "config/active_params.json"
  config.scope   = proc { |controller|
    "#{controller.request.method} #{controller.controller_name}/#{controller.action_name}"
  }
end
