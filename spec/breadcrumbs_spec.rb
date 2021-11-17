describe "breadcrumbs", type: :feature, js: true do
  describe "Enterprise", type: :feature, js: true do
    it "renders nested breadcrumbs correctly" do
      visit "/enterprise/2.5.x/plugin-development/custom-entities/"
      expect(find(".breadcrumb-item:nth-of-type(1)").text).to eq("KONG KONNECT PLATFORM")
      expect(find(".breadcrumb-item:nth-of-type(2)").text).to eq("Kong Gateway")
      expect(find(".breadcrumb-item:nth-of-type(3)").text).to eq("Plugin development")
    end

    it "renders nested breadcrumbs correctly" do
      visit "/gateway-oss/2.5.x/plugin-development/custom-entities/"
      expect(find(".breadcrumb-item:nth-of-type(1)").text).to eq("OPEN SOURCE")
      expect(find(".breadcrumb-item:nth-of-type(2)").text).to eq("Kong Gateway (OSS)")
      expect(find(".breadcrumb-item:nth-of-type(3)").text).to eq("Plugin development")
    end
  end

  describe "decK", type: :feature, js: true do
    it "renders the index page breadcrumbs correctly" do
      visit "/deck/"
      expect(find(".breadcrumb-item:nth-of-type(1)").text).to eq("OPEN SOURCE")
      expect(find(".breadcrumb-item:nth-of-type(2)").text).to eq("decK")
    end
  end

  describe "Gateway", type: :feature, js: true do
    it "renders the index page breadcrumbs correctly" do
      visit "/gateway/"
      expect(find(".breadcrumb-item:nth-of-type(1)").text).to eq("KONG KONNECT PLATFORM")
      expect(find(".breadcrumb-item:nth-of-type(2)").text).to eq("Kong Gateway")
    end
  end
end
