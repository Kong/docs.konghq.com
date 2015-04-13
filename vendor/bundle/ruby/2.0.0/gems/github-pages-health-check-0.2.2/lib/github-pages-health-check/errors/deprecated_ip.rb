class GitHubPages
  class HealthCheck
    class DeprecatedIP < Error
      def message
        "A record points to deprecated IP address"
      end
    end
  end
end
