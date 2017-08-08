class AdminController < ApplicationController
  layout 'back_stage'

  def show
    @api_form = APIForm.new
  end

  def update
    products = []
    shopify_client = ShopifyClient.new(**api_params)
    feed_generator = FeedGenerator.new(Rails.root.join('files', 'feed.xml'), Rails.root.join('files', 'schema.xsd'))

    with_exception_handler("Invalid Credentials") do
      response = shopify_client.get_collections
      data = JSON.parse(response.body)
      raise data["errors"] unless response.success?

      data["custom_collections"].each do |collection|
        response = shopify_client.get_products_in(collection: collection["id"])
        data_products = JSON.parse(response.body)
        raise data_products["errors"] unless response.success?

        products.concat data_products["products"].map{|prd| prd.merge({ collection: collection["title"], collection_handle: collection["handle"]})}
      end
    end

    with_exception_handler("Error Parsing") { feed_generator.generate_from(products) } if flash[:error].nil?

    if flash[:error].present?
      redirect_to admin_path
    else
      redirect_to '/feed.xml'
    end
  end

  private

  def with_exception_handler(category)
    begin
      yield
    rescue => e
      flash[:error] = "#{category} -- #{e.message}"
    end
  end

  def api_params
    params.require(:api).permit(:api_key, :password, :domain_name).to_h.symbolize_keys
  end
end