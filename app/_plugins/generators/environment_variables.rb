module Jekyll

  class EnvironmentVariablesGenerator < Generator
    def generate(site)
      site.config['git_branch'] = ENV['HEAD'] || 'main'
    end
  end

end