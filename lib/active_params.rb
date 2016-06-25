require "active_params/version"

module ActiveParams
  def write_strong_params(global_config: ActiveParams.global_config)
    current_config = global_config["#{request.method} #{controller_name}/#{action_name}"] ||= {}
    params.each do |k,v|
      case result = ActiveParams.strong_params_definition_for(v)
      when Array, Hash
        current_config[k] = result
      end
    end
    open(ActiveParams.path, "wb") {|f| f.write(JSON.pretty_generate(global_config)) }
    yield
  end

  def apply_strong_params(global_config: ActiveParams.global_config)
    # e.g. POST users#update
    current_config = global_config["#{request.method} #{controller_name}/#{action_name}"] ||= {}
    params.each do |k,v|
      if result = current_config[k]
        params[k] = params.require(k).permit(result)
      end
    end
    yield
  end

  def self.included(base)
    if base.methods.include? :around_action
      base.class_eval do
        around_action :write_strong_params if ActiveParams.development_mode?
        around_action :apply_strong_params
      end
    end
  end

  def self.development_mode?
    defined?(Rails) && Rails.env.development?
  end

  def self.path
    ENV.fetch("ACTIVE_PARAMS_PATH", "config/active_params.json")
  end

  def self.global_config
    @@global_config ||= (File.exists?(ActiveParams.path) ? JSON.parse(IO.read ActiveParams.path) : {})
  ensure
    # undo cache in development mode
    @@global_config = nil if development_mode?
  end

  # to obtain a hash of all possible keys
  def self.combine_hashes(array_of_hashes)
    array_of_hashes.select {|v| v.kind_of?(Hash) }.
      inject({}) {|sum, hash| hash.inject(sum) {|sum,(k,v)| sum.merge(k => v) } }
  end

  def self.strong_params_definition_for(params)
    if params.kind_of?(Array)
      combined_hash = combine_hashes(params)
      if combined_hash.empty?
        []
      else
        strong_params_definition_for(combined_hash)
      end
    elsif params.respond_to?(:keys) # Hash, ActionController::Parameters
      values, arrays = [[], {}]
      params.each do |key, value|
        case value
        when Array
          arrays[key] = strong_params_definition_for(value)
        when Hash
          arrays[key] = strong_params_definition_for(combine_hashes(value.values))
        else
          values.push(key)
        end
      end
      if arrays.empty?
        values
      else
        [*values.sort, arrays]
      end
    else
      params
    end
  end
end
