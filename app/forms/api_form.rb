class APIForm
  include Virtus::Model

  attribute :api_key, String
  attribute :password, String
  attribute :domain_name, String
end