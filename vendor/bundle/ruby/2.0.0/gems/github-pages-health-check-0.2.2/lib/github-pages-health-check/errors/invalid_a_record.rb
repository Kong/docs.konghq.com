class GitHubPages
  class HealthCheck
    class InvalidARecord < Error
      def message
        "Should not be an A record"
      end
    end
  end
end
