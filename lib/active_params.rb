require "active_params/version"
require "active_params/parser"
require "active_params/controller"

module ActiveParams
  # `include ActiveParams` use default settings
  def self.included(base)
    base.send(:include, setup)
  end

  # `include ActiveParams.setup({...})` customize
  def self.setup(options = {})
    Module.new do
      def self.included(base)
        base.send(:include, ActiveParams::Controller)
      end
    end.tap do |m|
      m.send(:define_method, :active_params_options) { options }
    end
  end
end
