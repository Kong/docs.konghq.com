require 'net/dns'
require 'net/dns/resolver'
require 'ipaddr'
require 'public_suffix'
require 'singleton'
require 'net/http'
require_relative 'github-pages-health-check/version'
require_relative 'github-pages-health-check/cloudflare'
require_relative 'github-pages-health-check/error'
require_relative 'github-pages-health-check/errors/deprecated_ip'
require_relative 'github-pages-health-check/errors/invalid_a_record'
require_relative 'github-pages-health-check/errors/invalid_cname'
require_relative 'github-pages-health-check/errors/not_served_by_pages'

class GitHubPages
  class HealthCheck

    attr_accessor :domain

    LEGACY_IP_ADDRESSES = %w[
      207.97.227.245
      204.232.175.78
      199.27.73.133
    ]

    def initialize(domain)
      @domain = domain
    end

    def cloudflare_ip?
      dns.all? { |answer| answer.class == Net::DNS::RR::A && CloudFlare.controls_ip?(answer.address) }
    end

    # Returns an array of DNS answers
    def dns
      @dns ||= without_warnings { Net::DNS::Resolver.start(domain).answer } if domain
    rescue Exception
      false
    end

    # Does this domain have *any* A record that points to the legacy IPs?
    def old_ip_address?
      dns.any? { |answer| answer.class == Net::DNS::RR::A && LEGACY_IP_ADDRESSES.include?(answer.address.to_s) }
    end

    # Is this domain's first response an A record?
    def a_record?
      dns.first.class == Net::DNS::RR::A
    end

    # Is this domain's first response a CNAME record?
    def cname_record?
      dns.first.class == Net::DNS::RR::CNAME
    end

    # Is this a valid domain that PublicSuffix recognizes?
    # Used as an escape hatch to prevent false positves on DNS checkes
    def valid_domain?
      PublicSuffix.valid? domain
    end

    # Is this domain an SLD, meaning a CNAME would be innapropriate
    def apex_domain?
      PublicSuffix.parse(domain).trd == nil
    rescue
      false
    end

    # Should the domain be an apex record?
    def should_be_a_record?
      !pages_domain? && apex_domain?
    end

    # Is the domain's first response a CNAME to a pages domain?
    def pointed_to_github_user_domain?
      dns.first.class == Net::DNS::RR::CNAME && pages_domain?(dns.first.cname.to_s)
    end

    # Is the given cname a pages domain?
    #
    # domain - the domain to check, generaly the target of a cname
    def pages_domain?(domain = domain())
      !!domain.match(/^[\w-]+\.github\.(io|com)\.?$/i)
    end

    # Is this domain owned by GitHub?
    def github_domain?
      !!domain.match(/\.github\.com$/)
    end

    def to_hash
      {
        :cloudflare_ip?                 => cloudflare_ip?,
        :old_ip_address?                => old_ip_address?,
        :a_record?                      => a_record?,
        :cname_record?                  => cname_record?,
        :valid_domain?                  => valid_domain?,
        :apex_domain?                   => apex_domain?,
        :should_be_a_record?            => should_be_a_record?,
        :pointed_to_github_user_domain? => pointed_to_github_user_domain?,
        :pages_domain?                  => pages_domain?,
        :served_by_pages?               => served_by_pages?,
        :valid?                         => valid?,
        :reason                         => reason
      }
    end

    def served_by_pages?
      scheme = github_domain? ? "https" : "http"
      uri = URI("#{scheme}://#{domain}")
      response = Net::HTTP.get_response(uri)
      response.to_hash["server"] == ["GitHub.com"]
    rescue
      false
    end

    def to_json
      to_hash.to_json
    end

    # Runs all checks, raises an error if invalid
    def check!
      return unless dns
      return if cloudflare_ip?
      raise DeprecatedIP if a_record? && old_ip_address?
      raise InvalidARecord if valid_domain? && a_record? && !should_be_a_record?
      raise InvalidCNAME if valid_domain? && !github_domain? && !apex_domain? && !pointed_to_github_user_domain?
      raise NotServedByPages unless served_by_pages?
      true
    end
    alias_method :valid!, :check!

    # Runs all checks, returns true if valid, otherwise false
    def valid?
      check!
      true
    rescue
      false
    end

    # Return the error, if any
    def reason
      check!
      nil
    rescue GitHubPages::HealthCheck::Error => e
      e
    end

    def inspect
      "#<GitHubPages::HealthCheck @domain=\"#{domain}\" valid?=#{valid?}>"
    end

    def to_s
      to_hash.inject(Array.new) do |all, pair|
        all.push pair.join(": ")
      end.join("\n")
    end

    private

    # surpress warn-level feedback due to unsupported record types
    def without_warnings(&block)
      warn_level, $VERBOSE = $VERBOSE, nil
      result = block.call
      $VERBOSE = warn_level
      result
    end
  end
end
