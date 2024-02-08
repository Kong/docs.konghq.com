RSpec.describe SEO::Tags::Title do
  before { generate_site!  }

  describe '#process' do
    subject! { described_class.new(page).process }

    context 'home' do
      let(:page) { find_page_by_url('/') }

      it { expect(page.data['title_tag']).to eq('Kong Docs') }
    end

    context 'hub pages' do
      context 'without version' do
        let(:page) { find_page_by_url('/hub/') }

        context 'page with <product> in the title' do
          it 'does not include the <product> section in the title' do
            expect(page.data['title_tag']).to eq('Kong Hub | Plugins and Integrations | Kong Docs')
          end
        end
      end

      context 'with version' do
        context 'latest' do
          let(:page) { find_page_by_url('/hub/kong-inc/jwt-signer/') }

          it { expect(page.data['title_tag']).to eq('Kong JWT Signer - Plugin | Kong Docs') }
        end

        context 'not latest' do
          let(:page) { find_page_by_url('/hub/kong-inc/jwt-signer/2.6.x/') }

          it { expect(page.data['title_tag']).to eq('Kong JWT Signer - Plugin - v2.6.x | Kong Docs') }
        end
      end
    end

    context 'product pages' do
      context 'without version' do
        let(:page) { find_page_by_url('/konnect/') }

        context 'page with <product> in the title' do
          it 'does not include the <product> section in the title' do
            expect(page.data['title_tag']).to eq('Kong Konnect | Kong Docs')
          end
        end
      end

      context 'with version' do
        context 'latest' do
          let(:page) { find_page_by_url('/kubernetes-ingress-controller/latest/introduction/') }

          it { expect(page.data['title_tag']).to eq('KIC Introduction - Kong Ingress Controller | Kong Docs') }
        end

        context 'not latest' do
          let(:page) { find_page_by_url('/kubernetes-ingress-controller/2.2.x/introduction/') }

          it { expect(page.data['title_tag']).to eq('KIC Introduction - Kong Ingress Controller - v2.2.x | Kong Docs') }
        end

        context 'labeled version' do
          let(:page) { find_page_by_url('/mesh/dev/') }

          it { expect(page.data['title_tag']).to eq('Kong Mesh - dev | Kong Docs') }
        end
      end

      context 'page with <product> in the title' do
        let(:page) { find_page_by_url('/gateway/latest/') }

        it 'does not include the <product> section in the title' do
          expect(page.data['title_tag']).to eq('Kong Gateway | Kong Docs')
        end
      end
    end

    context 'OAS pages' do
      context 'latest' do
        let(:page) { find_page_by_url('/gateway/api/admin-ee/latest/') }

        it { expect(page.data['title_tag']).to eq('Gateway Admin - EE (Beta) - OpenAPI Specifications | Kong Docs') }
      end

      context 'not latest' do
        let(:page) { find_page_by_url('/gateway/api/admin-ee/3.4.0.x/') }

        it { expect(page.data['title_tag']).to eq('Gateway Admin - EE (Beta) - OpenAPI Specifications - v3.4.0.x | Kong Docs') }
      end
    end

    context 'contributing guidelines pages' do
      let(:page) { find_page_by_url('/contributing/') }

      it { expect(page.data['title_tag']).to eq('Contributing to the Kong docs - Contribution Guidelines | Kong Docs') }
    end
  end
end
