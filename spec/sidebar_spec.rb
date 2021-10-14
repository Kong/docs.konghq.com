describe "sidebar", type: :feature, js: true do
  describe "Version Switcher", type: :feature, js: true do
    it "links to the same page if it exists in previous versions" do
      visit "/enterprise/2.5.x/deployment/installation/docker/"
      # Open up the navigation
      first("#version-dropdown").click
      expect(first('a[data-version-id="2.1.x"]')[:href]).to end_with('/enterprise/2.1.x/deployment/installation/docker/')
    end

    it "links to the root page if the page does not exist in previous versions" do
      visit "/enterprise/2.5.x/deployment/installation/docker/"
      # Open up the navigation
      first("#version-dropdown").click
      expect(first('a[data-version-id="0.34-x"]')[:href]).to end_with('/enterprise/0.34-x')
    end
  end

  describe "Outdated version documentation", type: :feature, js: true do

    # If the test is failing, make sure this is the latest version
    latest_version = "2.6.x"

    it "does not show on the latest version" do
      visit "/enterprise/#{latest_version}/deployment/installation/docker/"
      expect(page).not_to have_selector(".alert.alert-warning a", visible: true)
    end

    it "links to the same page" do
      visit "/enterprise/2.1.x/deployment/installation/docker/"
      expect(first('.alert.alert-warning a')[:href]).to end_with("/enterprise/#{latest_version}/deployment/installation/docker/")
    end

    it "links to the root when the page no longer exists" do
      visit "/enterprise/0.31-x/postgresql-redhat/"
      expect(first('.alert.alert-warning a')[:href]).to end_with("/enterprise/")
    end
  end

  describe "Gateway OSS", type: :feature, js: true do
    it "has the correct number of sidebar sections" do
      visit "/gateway-oss/"
      expect(page).to have_selector('.accordion-container > .accordion-item', count: 6)
    end
  end

  describe "decK", type: :feature, js: true do
    it "has the correct number of sidebar sections" do
      visit "/deck/"
      expect(page).to have_selector('.accordion-container > .accordion-item', count: 6)
    end
  end

  describe "Gateway Enterprise", type: :feature, js: true do
    it "has the correct number of sidebar sections" do
      visit "/enterprise/"
      expect(page).to have_selector('.accordion-container > .accordion-item', count: 11)
    end
  end
end
