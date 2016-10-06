class HashSerializer
  def self.dump(hash)
    hash.to_json
  end

  def self.load(hash)
    ActiveSupport::HashWithIndifferentAccess.new(hash.is_a?(String) ? JSON.parse(hash) : hash)
  end
end
