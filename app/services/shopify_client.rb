class ShopifyClient
  include HTTParty

  def initialize(api_key:, password:, domain_name:)
    @uri = "https://#{api_key}:#{password}@#{domain_name}/admin"
  end

  def get_products
    self.class.get("#{@uri}/products.json")
  end

  def get_products_in(collection:)
    puts "#{@uri}/products.json?collection_id=#{collection}"
    self.class.get("#{@uri}/products.json?collection_id=#{collection}")
  end

  def get_collections
    self.class.get("#{@uri}/custom_collections.json")
  end
end