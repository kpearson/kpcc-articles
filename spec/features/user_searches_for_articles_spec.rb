require "rails_helper"

describe "User searches for articles" do
  let!(:search_term) { "virgin galactic" }

  it "they see the page with the articles" do
    search_for search_term

    expect(page).to have_content "How aerospace is making a comeback in Southern California"
  end

  it 'results include a links to audio files' do
    search_for search_term
    expect(page).to have_link "Listen", href: "http://media.scpr.org/audio/features/20160421_features1021.mp3?via=api"
    expect(page).to have_css "a", count: 5
  end
end

def search_for(search_term)
  visit root_path
  fill_in "Search for", with: search_term
  click_on "Search"
end
