require "json"

module ActiveParams
  module Controller
    def self.included(base)
      add_before_method =
        (base.methods.include?(:before_action) && :before_action) ||
        (base.methods.include?(:before_filter) && :before_filter)

      if add_before_method
        base.class_eval do
          send add_before_method, :active_params_write, if: :active_params_writing?
          send add_before_method, :active_params_apply
        end
      end
    end

    def active_params_writing?
      active_params_options[:writing] || defined?(Rails) && Rails.env.development?
    end

    def active_params_path
      active_params_options[:path] || ENV.fetch("ACTIVE_PARAMS_PATH", "config/active_params.json")
    end

    def active_params_json
      @@active_params_json ||= (File.exists?(active_params_path) ? JSON.parse(IO.read active_params_path) : {})
    rescue JSON::ParserError
      return {}
    ensure
      # undo cache in development mode
      @@active_params_json = nil if active_params_writing?
    end

    def active_params_scope
      scope = active_params_options[:scope]
      if scope.respond_to?(:call)
        scope.call(self)
      else
        active_params_default_scope
      end
    end

    def active_params_default_scope
      "#{request.method} #{controller_name}/#{action_name}"
    end

    def active_params_write(global_json: active_params_json)
      scoped_json = global_json[active_params_scope] ||= {}
      params.each do |k,v|
        case result = ActiveParams::Parser.strong_params_definition_for(v)
        when Array, Hash
          scoped_json[k] = result
        end
      end
      open(active_params_path, "wb") {|f| f.write(JSON.pretty_generate(global_json)) }
    end

    def active_params_apply(global_json: active_params_json)
      # e.g. POST users#update
      scoped_json = global_json[active_params_scope] ||= {}
      params.each do |k,v|
        if result = scoped_json[k]
          params[k] = params.require(k).permit(result)
        end
      end
    end
  end
end