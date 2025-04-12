# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "rubyrag", path: "."
end

client = Rubyrag.new(provider: :cloudflare_auto_rag,
                     bucket: "<bucket name>",
                     access_key_id: "<bucket s3_access_key>",
                     secret_access_key: "<bucket s3_secret_key>",
                     r2_endpoint: "<r2 endpoint url>",
                     autorag_endpoint: "<autorag endpoint url>",
                     autorag_access_token: "<autorag access token>")

r2_response = client.add(file_path: File.expand_path("<File path>", __dir__))

p r2_response

ai_response = client.query(query: "Gemfile for rubyrag")

p ai_response
