# frozen_string_literal: true

class ProductsRenderer
  MAPPINGS = {
    'kic' => 'kubernetes-ingress-controller'
  }.freeze

  def products
    @products ||= ENV.fetch('KONG_PRODUCTS', '')
                     .split(',')
                     .map { |p| p.split(':') }
                     .map { |p, v| [MAPPINGS.fetch(p, p), v&.split(';')] }
                     .each_with_object({}) { |(p, v), hash| hash[p] = v }
  end

  def read?(page)
    return true if page.relative_path.start_with?('assets')

    products.any? do |product, _versions|
      page.relative_path == 'index.html' || page.relative_path.start_with?(product)
    end
  end

  def render?(page) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/MethodLength
    return true if page.relative_path.start_with?('assets')

    products.any? do |product, versions|
      return true if page.dir == '/'

      case product
      when '*'
        versions.any? { |v| page.dir.start_with?(%r{/(\w|-)+/#{v}/}) }
      else
        (versions.nil? && page.dir.start_with?("/#{product}")) ||
          (!versions.nil? && versions.any? { |v| page.dir.start_with?(%r{/#{product}/#{v}}) })
      end
    end
  end
end

renderer = ProductsRenderer.new

Jekyll::Hooks.register :site, :post_read do |site|
  if ENV['KONG_PRODUCTS']
    Jekyll.logger.info "Rendering the following products: #{ENV['KONG_PRODUCTS']}, skipping everything else..."

    site.pages = site.pages.select { |page| renderer.read?(page) }
  end
end

Jekyll::Hooks.register :site, :pre_render do |site|
  if ENV['KONG_PRODUCTS']
    site.pages = site.pages.select do |page|
      renderer.render?(page)
    end
  end
end
