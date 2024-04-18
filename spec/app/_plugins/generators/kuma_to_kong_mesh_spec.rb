RSpec.describe KumaToKongMesh::Generator do
  let(:page) do
    site.pages.detect { |p| p.relative_path == 'kuma-to-kong-mesh.md' }
  end

  before do
    page.data['path'] = "_src/.repos/kuma/#{page.relative_path}"
  end

  describe '#generate' do
    subject! { described_class.new.generate(site) }

    it 'replaces `Kuma` with `Kong Mesh` in the title' do
      expect(page.data['title']).to eq('Welcome to Kong Mesh')
    end

    context 'updates the page\'s content' do
      context 'links containing `kuma` in them' do
        it 'replaces `kuma` with `kong-mesh`' do
          expect(page.content)
            .not_to include('[Read about Kuma](/docs/{{ page.version }}/introduction/what-is-kuma)')

          expect(page.content)
            .to include('[Read about Kuma](/mesh/{{ page.release }}/introduction/what-is-kong-mesh)')
        end

        it 'do not replace `kuma.io` and kumaio in links' do
          expect(page.content).to include('https://kong.io#kumaioanchor')
        end

        it 'work with kuma more than once in a link' do
          expect(page.content).to include('/foo-kong-mesh#kong-mesh')
        end

        it 'does not modify absolute urls' do
          expect(page.content).to include(
            '[Demo app downloaded from GitHub](https://github.com/kumahq/kuma-counter-demo)'
          )
        end

        it 'does not replace `kuma` in links that contain kuma commands' do
          expect(page.content).to include('/mesh/{{ page.release }}/generated/cmd/kuma-cp/kuma-cp_migrate')
          expect(page.content).to include('/mesh/{{ page.release }}/generated/cmd/kuma-dp/kuma-dp_run')
          expect(page.content).to include('/mesh/{{ page.release }}/generated/cmd/kumactl/kumactl_apply')
        end

        context 'assets' do
          it 'does not replace `kuma` in assets' do
            expect(page.content).to include('<img src="/assets/images/docs/0.4.0/kuma_dp1.jpeg"')
            expect(page.content).to include('<img src="/assets/images/docs/0.4.0/kuma_dp2.png"')
            expect(page.content).to include('<img src="/assets/images/docs/0.4.0/kuma_dp3.png"')
            expect(page.content).to include('<img src="/assets/images/docs/1.1.2/kuma_dp4.png"')
          end
        end
      end

      context 'transforms specific links' do
        it 'replaces `/install` and `/install/` with `/mesh/{{ page.release }}/install/`' do
          expect(page.content).not_to include('[Install Kuma](/install)')

          expect(page.content).to include('[Install Kuma](/mesh/{{ page.release }}/install/)').twice
        end

        it 'replaces `/community` and `/community/` with `https://konghq.com/community`' do
          expect(page.content).not_to include('[Community](/community)')

          expect(page.content).to include('[Community](https://konghq.com/community)').twice
        end

        it 'replaces `/enterprise` and `/enterprise/` with `/mesh/{{ page.release }}/`' do
          expect(page.content).not_to include('[Enterprise Support](/enterprise)')

          expect(page.content).to include('[Enterprise Support](/mesh/{{ page.release }}/)').twice
        end
      end

      context 'replaces the base url from Kuma' do
        it 'replaces `/docs/{{ page.version }}` with `/mesh/{{ page.release }}`' do
          expect(page.content).not_to include('/docs/{{ page.version }}')

          expect(page.content).to include('/mesh/{{ page.release }}').exactly(10).times
        end
      end
    end
  end
end
