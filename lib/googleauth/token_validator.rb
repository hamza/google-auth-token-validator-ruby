require "net/http"
require "json"
require "base64"
require "openssl"

module Google
  module Auth
    class TokenValidator
      GOOGLE_SIGNON_CERTS_URL    = "https://www.googleapis.com/oauth2/v1/certs".freeze
      ISSUERS                    = %w(accounts.google.com https://accounts.google.com).freeze
      CLOCK_SKEW_SECONDS         = 300 # five minutes
      MAX_TOKEN_LIFETIME_SECONDS = 86400 # one day

      attr_reader :signed, :signature, :envelope, :payload, :client_id

      def initialize jwt, client_id
        segments = jwt.split(".")

        fail Error, "Wrong number of segments in token: #{jwt}" unless segments.size.eql? 3

        @client_id = client_id

        @signed = "#{segments[0]}.#{segments[1]}"
        @signature = segments[2]

        @envelope = JSON.parse Base64.decode64(segments[0])
        @payload = JSON.parse Base64.decode64(segments[1])
      end

      def validate max_expiry = MAX_TOKEN_LIFETIME_SECONDS
        unless [@signed, @signature, @envelope, @payload].all?
          fail Error, "Validator was not properly initialized"
        end

        unless self.class._certs.keys.include? @envelope["kid"]
          fail Error, "No matching Google cert found for envelope: #{@envelope}"
        end

        pem = self.class._certs[envelope["kid"]]
        cert = OpenSSL::X509::Certificate.new pem
        digest = OpenSSL::Digest::SHA256.new

        verified = cert.public_key.verify(digest, Base64.urlsafe_decode64(@signature), @signed)

        fail Error, "Token signature invalid" unless verified

        fail Error, "No issue time in token" if @payload["iat"].to_s.empty?
        fail Error, "No expiration time in token" if @payload["exp"].to_s.empty?

        now      = Time.now.to_i
        earliest = @payload["iat"] - CLOCK_SKEW_SECONDS
        latest   = @payload["exp"] + CLOCK_SKEW_SECONDS

        fail Error, "Expiration time too far in future" if @payload["exp"] >= Time.now.to_i + max_expiry
        fail Error, "Token used too early" if now < earliest
        fail Error, "Token used too late" if now > latest

        unless ISSUERS.include? @payload["iss"]
          fail Error, "Invalid issuer. Expected one of #{ISSUERS}, but got #{@payload["iss"]}"
        end

        if @client_id.is_a? Array
          aud_verified = @client_id.include?(@payload["aud"])
        elsif @client_id.is_a? String
          aud_verified = @payload["aud"] == @client_id
        else
          fail Error, "Invalid client id(s)"
        end

        unless aud_verified
          fail Error, "Wrong recipient - payload audience doesn't match required audience"
        end

        return true
      end

      class << self
        attr_accessor :_cached_certs

        def _certs
          @_cached_certs ||= begin
            uri = URI(GOOGLE_SIGNON_CERTS_URL)
            JSON.parse Net::HTTP.get(uri)
          end
        end
      end

      class Error < StandardError; end
    end
  end
end
