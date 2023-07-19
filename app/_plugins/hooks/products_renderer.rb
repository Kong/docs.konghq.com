# frozen_string_literal: true

class ProductsRenderer
  def products
    @products ||= ENV.fetch('KONG_PRODUCTS', '')
                     .split(',')
                     .map { |p| p == 'kic' ? 'kubernetes-ingress-controller' : p }
  end

  def read?(page)
    products.any? do |product|
      page.relative_path == 'index.html' || page.relative_path.start_with?(product)
    end
  end

  def render?(page)
    products.any? do |product|
      page.dir == '/' || page.dir.start_with?("/#{product}")
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
