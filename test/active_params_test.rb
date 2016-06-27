require 'test_helper'

class ActiveParamsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ActiveParams::VERSION
  end

  # `include ActiveParams`
  def test_defalut
    value = rand
    klass = Class.new do
      include ActiveParams
    end
    klass.send :define_method, :active_params_default_scope do
      value
    end
    assert_equal nil, klass.new.active_params_writing?
    assert_equal ENV.fetch("ACTIVE_PARAMS_PATH", "config/active_params.json"), klass.new.active_params_path
    assert_equal value, klass.new.active_params_scope
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
