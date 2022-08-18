class RemoveUploadersFromModelYAMLDumpService
  ALIAS_REGEXP = /^\s*\w+:\s&(?<alias>\d+)\s(?<value>.+)/.freeze
  ALIAS_VALUE_REGEXP = /\*(\d+)$/.freeze
  UPLOADER_REGEXP = %r{!ruby/object:\w+Uploader}.freeze

  def self.call(string)
    result_object =
      string
        .split("\n")
        .each_with_object(init_new_acc) do |substring, acc|
        current_padding_size = padding_size(substring)
        is_padding_deeper = padding_deeper?(acc, current_padding_size)

        memorize_aliases(substring, acc)

        if value_found?(substring, acc, is_padding_deeper)
          on_value_found(substring, acc)
        elsif is_padding_deeper
          next
        elsif acc.attribute_name.present?
          acc.attribute_name = nil

          acc.result.concat("#{substring}\n")
        elsif substring.match?(UPLOADER_REGEXP)
          on_uploader_found(substring, acc, current_padding_size)
        else
          acc.result.concat("#{substring}\n")
        end
      end

    replace_aliase_with_values(result_object.result, result_object.aliases)
  end

  private_class_method def self.memorize_aliases(string, acc)
    match = string.match(ALIAS_REGEXP)

    return unless match

    acc.aliases[match[:alias]] = match[:value]
  end

  private_class_method def self.replace_aliase_with_values(string, aliases)
    string.scan(ALIAS_VALUE_REGEXP).flatten.uniq.inject(string) do |acc, alias_name|
      acc.gsub!("*#{alias_name}\n", "#{aliases[alias_name]}\n")
    end
  end

  private_class_method def self.init_new_acc
    OpenStruct.new({
                     aliases: {},
                     attribute_name: nil,
                     attribute_name_regex: nil,
                     attribute_padding_size: 0,
                     is_value_awaiting: true,
                     result: ''
                   })
  end

  private_class_method def self.padding_size(string)
    string.length - string.lstrip.length
  end

  private_class_method def self.padding_deeper?(acc, current_padding_size)
    acc.attribute_name.present? && acc.attribute_padding_size < current_padding_size
  end

  private_class_method def self.value_found?(substring, acc, is_padding_deeper)
    acc.is_value_awaiting && is_padding_deeper && acc.attribute_name_regex.match?(substring)
  end

  private_class_method def self.on_value_found(substring, acc)
    value = substring.split(': ').last
    acc.is_value_awaiting = false

    acc.result.concat("#{' ' * acc.attribute_padding_size}#{acc.attribute_name}: #{value}\n")
  end

  private_class_method def self.on_uploader_found(substring, acc, current_padding_size)
    acc.attribute_name = substring.split(':').first.lstrip
    acc.attribute_name_regex = Regexp.new(/^\s+#{Regexp.quote(acc.attribute_name)}: [\w\-]+\.\w{3,4}$/)
    acc.attribute_padding_size = current_padding_size
  end
end
