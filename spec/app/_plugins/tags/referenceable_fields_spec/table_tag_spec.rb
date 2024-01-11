RSpec.describe Jekyll::ReferenceableFieldsTable do
  let(:version) { '3.2.x' }
  let(:hub) do
    [
      instance_double('PluginSingleSource::SingleSourcePage', data: { 'extn_slug' => 'aws-lambda', 'name' => 'AWS Lambda' } ),
      instance_double('PluginSingleSource::SingleSourcePage', data: { 'extn_slug' => 'datadog', 'name' => 'Datadog' } )
    ]
  end

  let(:json) do
    <<~JSON
          {
            "aws-lambda": [
              "config.aws_key",
              "config.aws_secret",
              "config.aws_assume_role_arn"
            ],
            "datadog": [
              "config.host"
            ]
          }
    JSON
  end

  before do
    allow(File).to receive(:read).and_call_original

    expect(File)
      .to receive(:read)
      .with('app/_src/.repos/kong-plugins/data/referenceable_fields/3.2.x.json')
      .and_return(json)
  end

  describe '#render' do
    let(:site) { OpenStruct.new('data' => { 'ssg_hub' => hub }) }
    let(:page) { { 'release' => '3.2.x' } }
    let(:environment) { { 'page' => page } }
    let(:liquid_context) { Liquid::Context.new(environment, {}, site: site) }
    let(:tag) do
      described_class.parse(
        'referenceable_fields_table',
        '',
        Liquid::Tokenizer.new(''),
        Liquid::ParseContext.new
      )
    end

    subject { Capybara::Node::Simple.new(tag.render(liquid_context)) }

    it 'renders a table listing all the plugins that have referenceable fields' do
      expect(subject).to have_css('thead th', text: 'Plugin')
      expect(subject).to have_css('thead th', text: 'Referenceable fields')

      aws_lambda = subject.find('tbody tr:nth-of-type(1)')
      expect(aws_lambda).to have_link('AWS Lambda', href: '/hub/kong-inc/aws-lambda/configuration/')
      expect(aws_lambda).to have_css('td', text: 'config.aws_key config.aws_secret config.aws_assume_role_arn', normalize_ws: true)

      datadog = subject.find('tbody tr:nth-of-type(2)')
      expect(datadog).to have_link('Datadog', href: '/hub/kong-inc/datadog/configuration/')
      expect(datadog).to have_css('td', text: 'config.host', normalize_ws: true)
    end

    it 'reders a note about the vault plugin' do
      expect(subject).to have_content('The Vault plugin interacts with the `vaults` and `vault_credentials` entities.')
    end
  end

  describe Jekyll::ReferenceableFields do
    describe '.run' do
      subject { described_class.run(version:, hub:) }

      it 'returns a hash with the plugin\'s referenceable fields' do
        expect(subject).to eq({
          'aws-lambda' => ['AWS Lambda', ['config.aws_key', 'config.aws_secret', 'config.aws_assume_role_arn']],
          'datadog' => ['Datadog', ['config.host']]
        })
      end
    end
  end
end
