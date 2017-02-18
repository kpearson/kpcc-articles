require "rails_helper"

describe "User searches for articles" do
  it "they see the page with the articles" do
    search_term = "virgin galactic"

    visit root_path
    fill_in "Search for", with: search_term
    click_on "Search"

    expect(page).to have_content "How aerospace is making a comeback in Southern California"
  end
end
