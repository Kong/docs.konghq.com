# frozen_string_literal: true

module SupportedVersionApi
  def self.process(site) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    versions = site.data['kong_versions'].select { |version| version['edition'] == 'gateway' }
    versions = versions.map do |version|
      date = nil
      sunset_date = nil
      unless version['endOfLifeDate'].nil?
        date = version['endOfLifeDate'].to_s
        sunset_date = version['endOfLifeDate'].next_year.to_s
      end

      {
        release: version['release'],
        tag: version['release'].gsub('.x', ''),
        endOfLifeDate: date,
        endOfsunset_date: sunset_date,
        label: version['label']
      }
    end

    FileUtils.mkdir_p("#{site.dest}/_api")
    File.write("#{site.dest}/_api/gateway-versions.json", versions.to_json)
  end
end

Jekyll::Hooks.register :site, :post_write do |site, _|
  SupportedVersionApi.process(site)
end
