describe "homepage", type: :feature, js: true do
  it "has the 'Welcome to Kong' header" do
    visit "/"
    expect(find(".landing-page h1").text).to eq("Welcome to Kong Docs")
  end

  # Test commented out while the promo banner is inactive
  # it "shows the blue promo banner", js: true do
  #   visit "/"
  #   expect(page).to have_selector("#promo-banner", visible: true)
  # end
end
