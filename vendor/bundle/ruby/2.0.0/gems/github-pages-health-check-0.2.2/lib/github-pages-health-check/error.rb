class GitHubPages
  class HealthCheck
    class Error < StandardError
      def message
        "Invalid domain"
      end
      def to_s
        message
      end
    end
  end
end
