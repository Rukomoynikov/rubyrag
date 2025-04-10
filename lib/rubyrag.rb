# frozen_string_literal: true

require "rubyrag/cloudflare_auto_rag"

class Rubyrag
  attr_reader :rag

  class Error < StandardError; end

  def initialize(provider:, **options)
    @rag = case provider
           when :cloudflare_auto_rag
             Rubyrag::Rags::CloudflareAutoRag.new(options)
           else
             raise Error("Invalid provider: #{provider}")
           end
  end

  def add(**options)
    rag.add(**options)
  end

  def query(**options)
    rag.query(**options)
  end
end
