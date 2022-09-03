class GetVersionChangesService
  SCREENED_KEYS = %w[encrypted_password reset_password_token].freeze

  def self.call(version)
    prev_version_attributes = prev_attributes(version)
    next_version_attributes = next_attributes(version)

    if prev_version_attributes.empty? || next_version_attributes.empty?
      [prev_version_attributes, next_version_attributes]
    else
      keys = prev_version_attributes.keys.concat(next_version_attributes.keys).uniq

      keys.each_with_object([{}, {}]) do |key, (prev_diff, next_diff)|
        prev_value = prev_version_attributes[key]
        next_value = next_version_attributes[key]

        unless prev_value == next_value
          prev_diff[key] = screened_value(prev_value, key)
          next_diff[key] = screened_value(next_value, key)
        end

        [prev_diff, next_diff]
      end
    end
  end

  private_class_method def self.screened_value(value, key)
    if SCREENED_KEYS.include?(key)
      '********'
    else
      value
    end
  end

  private_class_method def self.prev_attributes(version)
    case version.event
    when 'create'
      {}
    when 'update', 'destroy'
      version.reify.attributes
    else
      { unknown_event: version.event }
    end
  end

  private_class_method def self.next_attributes(version)
    case version.event
    when 'create'
      (next_reify(version) || version.item).attributes
    when 'update'
      (next_reify(version) || version.item.reload).attributes
    when 'destroy'
      {}
    else
      { unknown_event: version.event }
    end
  end

  private_class_method def self.next_reify(version)
    version.next&.reify
  end
end
