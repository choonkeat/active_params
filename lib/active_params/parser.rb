module ActiveParams
  module Parser
    # to obtain a hash of all possible keys
    def combine_hashes(array_of_hashes)
      array_of_hashes.select {|v| v.kind_of?(Hash) }.
        inject({}) {|sum, hash| hash.inject(sum) {|sum,(k,v)| sum.merge(k => v) } }
    end

    def strong_params_definition_for(params)
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

    self.extend(self)
  end
end
