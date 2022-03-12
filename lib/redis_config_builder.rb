class RedisConfigBuilder
  def self.build(namespace = nil)
    new.build(namespace)
  end

  def build(namespace = nil)
    default_config.tap do |config|
      config[:namespace] = "#{config[:namespace]}-#{namespace}" if namespace.present?
      config[:ssl_params] = {verify_mode: OpenSSL::SSL::VERIFY_NONE} if ENV.fetch('REDIS_SSL', '0') == '1'
    end
  end

  private

  def default_config
    {
      url: ENV["REDIS_URL"],
      namespace: ENV["REDIS_NAMESPACE"],
      network_timeout: 3,
      driver: :ruby
    }
  end
end
