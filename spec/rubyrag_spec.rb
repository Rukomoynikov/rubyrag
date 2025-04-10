# frozen_string_literal: true

require "aws-sdk-s3"
require "debug"

RSpec.describe Rubyrag do
  let(:rubyrag_client) do
    Rubyrag.new(provider: :cloudflare_auto_rag,
                access_key_id: "access_key_id",
                secret_access_key: "secret_access_key",
                r2_endpoint: "http://endpoint.com",
                autorag_endpoint: "http://endpoint.com",
                autorag_access_token: "autorag_access_token")
  end
  let(:s3_put_object_response) do
    Aws::S3::Types::PutObjectOutput.new(
      expiration: nil,
      etag: "\"d41d8cd98f00b204e9800998ecf8427e\"",
      checksum_crc32: "AAAAAA==",
      checksum_crc32c: nil,
      checksum_crc64nvme: nil,
      checksum_sha1: nil,
      checksum_sha256: nil,
      checksum_type: nil,
      server_side_encryption: nil,
      version_id: "7e69df14a23db5e1310e81d2d290b210",
      sse_customer_algorithm: nil,
      sse_customer_key_md5: nil,
      ssekms_key_id: nil,
      ssekms_encryption_context: nil,
      bucket_key_enabled: nil,
      size: nil,
      request_charged: nil
    )
  end

  describe "add" do
    it "can add text content to index" do
      expect_any_instance_of(
        Aws::S3::Client
      ).to receive(:put_object).and_return(s3_put_object_response)

      rubyrag_client.add(file_path: File.expand_path("spec_helper.rb", __dir__))
    end

    context "when file doesnt exist" do
      it "raises an error" do
        expect do
          rubyrag_client.add(file_path: File.expand_path("non_exsiting_file.rb", __dir__))
        end.to raise_error(Rubyrag::Rags::CloudflareAutoRag::Error)
      end
    end
  end

  describe "query" do
    let(:autorag_response) do
      Struct.new("ClassName") do |_new_class|
        def body
          "{\"success\":true,\"result\":{\"object\":\"vector_store.search_results.page\",\"search_query\":\"query\",\"response\":\"I couldn't find any relevant documents related to your query. Unfortunately, this means I won't be able to provide an answer based on the content of retrieved documents. If you'd like, I can try to provide a general response based on my knowledge, but please note that it won't be derived from any specific documents. Would you like me to attempt a response without using documents?\",\"data\":[],\"has_more\":false,\"next_page\":null}}"
        end
      end
    end

    it "can query index with search query" do
      expect_any_instance_of(
        Net::HTTP
      ).to receive(:request).and_return(autorag_response.new)

      rubyrag_client.query(query: "query")
    end
  end
end
