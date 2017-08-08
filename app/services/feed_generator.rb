class FeedGenerator
  def initialize(file_path, schema_path)
    @file_path = file_path
    @schema_path = schema_path
  end

  def generate_from(products)
    xml = Nokogiri::XML::Builder.new { |xml|
      xml.items do
        products.each do |prd|
          prd = prd.with_indifferent_access
          xml.item do
            xml.product prd["title"]
            xml.description prd["body_html"]
            xml.url prd["handle"]
            xml.image_url prd["image"]["src"] if prd["image"].present?
            xml.brand prd["vendor"]
            xml.first_category prd["collection"], :url_value => prd["collection_handle"]
            xml.sku sku(prd)
            xml.price price(prd)
          end
        end
      end
    }

    if valid?(xml.to_xml)
      File.open(@file_path, 'w') do |file|
        file.write xml.to_xml
      end
    else
      raise "Invalid Schema!"
    end
  end

  private

  def valid?(xml)
    xsd = Nokogiri::XML::Schema(File.read(@schema_path))
    document = Nokogiri::XML(xml)
    xsd.validate(document).each do |error|
      puts error.message
    end
    xsd.valid?(document)
  end

  def sku(product)
    if product["variants"].first["sku"].present?
      product["variants"].first["sku"]
    else
      "N/A"
    end
  end

  def price(product)
    product["variants"].first["price"]
  end
end