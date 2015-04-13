class GitHubPages
  class HealthCheck
    class CloudFlare
      include Singleton

      CONFIG_PATH = File.expand_path("../../config/cloudflare-ips.txt", File.dirname(__FILE__))

      # Public: Does cloudflare control this address?
      def self.controls_ip?(address)
        instance.controls_ip?(address)
      end

      # Internal: Create a new cloudflare info instance.
      def initialize(options = {})
        @path = options.fetch(:path) { CONFIG_PATH }
      end

      # Internal: The path of the config file.
      attr_reader :path

      # Internal: Does cloudflare control this address?
      def controls_ip?(address)
        ranges.any? { |range| range.include?(address) }
      end

      # Internal: The IP address ranges that cloudflare controls.
      def ranges
        @ranges ||= load_ranges
      end

      # Internal: Load IPAddr ranges from #path
      def load_ranges
        File.read(path).lines.map { |line| IPAddr.new(line.chomp) }
      end
    end
  end
end
