require 'test_helper'

class ActiveParamsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ActiveParams::VERSION
  end

  # `include ActiveParams`
  # `ActiveParams.config`
  def test_default
    value = rand
    klass = Class.new do
      def request; Struct.new(:method).new("GET"); end
      def controller_name; "home"; end
      def action_name; "index"; end
      include ActiveParams
    end
    instance = klass.new
    assert_equal nil, instance.active_params_writing?
    assert_equal ENV.fetch("ACTIVE_PARAMS_PATH", "config/active_params.json"), instance.active_params_path
    assert_equal "GET home/index", instance.active_params_scope
  end

  # `include ActiveParams.setup...`
  def test_setup_writing
    value = rand
    klass = Class.new do
      include ActiveParams.setup(writing: value)
    end
    assert_equal value, klass.new.active_params_writing?
  end

  def test_setup_path
    value = rand
    klass = Class.new do
      include ActiveParams.setup(path: value)
    end
    assert_equal value, klass.new.active_params_path
  end

  def test_setup_scope
    value = rand
    klass = Class.new do
      include ActiveParams.setup(scope: proc { value })
    end
    assert_equal value, klass.new.active_params_scope
  end
end
