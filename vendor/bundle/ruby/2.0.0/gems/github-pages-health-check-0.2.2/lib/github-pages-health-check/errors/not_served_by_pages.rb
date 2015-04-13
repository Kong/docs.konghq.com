class GitHubPages
  class HealthCheck
    class NotServedByPages < Error
      def message
        "Domain does not resolve to the GitHub Pages server"
      end
    end
  end
end
