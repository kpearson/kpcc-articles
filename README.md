# KPCC Article Search

A simple search interface for the KPCC article archive.

## Set Up

To get started using this app locally, from within the local app directory run
the following commands in your favorite terminal application.

1. `Bundle install`
2. `Rails server`
3. Use a web browser and navigate to localhoast:3000 and start searching.

> Note: This app is not built to store data of any kind, so there is no need to
run any of the normal Rails database setup commands.

## Development Set Up

This app is built using Ruby on Rails with Rspec.

1. `Bundle install`
2. `rspec`

## To do

This list is a way to track progress as well as a place for feature adds and bug
fixes as I'm building.

- [ ] Add the VCR gem to reduce hits to the target API when testing.
- [x] Refine the "types" in the request. Located in the service adapter.
  `app/services/kpcc_api_service.rb:28`

### Results Page

A few interface ideas for the results page.

#### Header

Build a header with:
- [x] An app title
- [ ] Search field to a header next to the app title.
- [x] Search results count. Time for a decorator?

     ```ruby
     <p><%= @search_results.count %> articles found</p>
     ```

Later iteration:

- [ ] Search filter for type of article.
  - NewsStory (news, news_story)
  - BlogEntry (blogs, blog_entry)
  - ShowSegment (segments, show_segment)

#### Results

- [x] Show audio file link if result has audio file.  
  (I'd like to see a better way, but this will get us there for now.)
     ```ruby
     <% if result.audio_url %>
       <%= link_to "Listen", result.audio_url %>
     <% end %>
     ```
- [ ] Pagination - Looks tricky as the API response does not provide next
  and last page links nor does it give a total number of results.

Later iteration:

- [ ] Interface to play audio file from results page, instead of a link.

### Styling

- [x] Style initial search page to match spec.
- [x] Style results page header.
- [x] Style results page results.
