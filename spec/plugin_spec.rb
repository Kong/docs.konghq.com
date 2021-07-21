describe "plugins", type: :feature, js: true do
  it "renders the plugin card CSS correctly" do
    # This means that hub.css has been included
    visit "/hub/"
    expect(first(".plugin-card")).to match_style("display" => "flex")
  end

  # These tests ensure that the generated samples are correct
  # We had a caching issue previously where they all showed the same information
  describe "shows the correct sample", type: :feature, js: true do

    # Set a baseline on a common plugin (basic-auth)
    it "basic-auth (kong inc)" do
      visit "/hub/kong-inc/basic-auth/"
      expect(first(".navtab-content").text).to include('--data "name=basic-auth"')
    end

    # Make sure that a different plugin shows the correct name too
    # In case we cached basic-auth by coincidence
    it "cors (kong inc)" do
      visit "/hub/kong-inc/cors/"
      expect(first(".navtab-content").text).to include('--data "name=cors"')
    end

    # Show a community contributed plugin too
    it "salt (community)" do
      visit "/hub/salt/salt/"
      expect(first(".content").text).to include('--data "name=salt-agent" \\')
    end
  end
end
