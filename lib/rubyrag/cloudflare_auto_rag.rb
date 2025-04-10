# frozen_string_literal: true

require "aws-sdk-s3"
require "digest"
require "net/http"
require "uri"
require "json"

class Rubyrag
  class Rags
    class CloudflareAutoRag
      attr_reader :client, :options

      class Error < StandardError; end

      DEFAULT_OPTIONS = {
        region: "auto"
      }.freeze

      def initialize(options)
        @options = options.merge(DEFAULT_OPTIONS)

        @client = Aws::S3::Client.new(
          access_key_id: options[:access_key_id],
          secret_access_key: options[:secret_access_key],
          endpoint: options[:r2_endpoint],
          region: "auto"
        )
      end

      def add(file_path:, key: nil)
        raise Error, "Passed file: #{file_path}" unless File.exist?(file_path)

        client.put_object(
          bucket: options[:bucket],
          key: key || Digest::MD5.file(file_path).hexdigest,
          content_length: File.size(file_path),
          body: File.open(file_path)
        )
      end

      def query(query:)
        raise Error, "Invalid or empty query provided" unless query.length.positive?

        uri = URI("#{options[:autorag_endpoint]}/ai-search")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.path, {
                                        "Content-Type" => "application/json",
                                        "Authorization" => "Bearer #{options[:autorag_access_token]}"
                                      })

        request.body = { query: query }.to_json

        response = http.request(request)

        JSON.parse(response.body)
      end
    end
  end
end
