# KPCC Article Search

A simple search interface for the KPCC article archive.

## Todos

* [] Add the VCR gem to reduce hits to the target API when testing.
* [] Check how the "types" in the request are being formatted in the request
     service adapeter. `app/services/kpcc_api_service.rb:28`
* [] Test for case sensitivity in search.

### Results Page

A few interface ideas for the results page.

#### Header

Build a header with:
* [] An app title
* [] Search field to a header next to the app title.
* [] Search results count.
     Time for a decorator?
     ```ruby
     <p><%= @search_results.count %> articles found</p>
     ```

Later iteration.

* [] Search filter for type of article.
       NewsStory (news, news_story)
       BlogEntry (blogs, blog_entry)
       ShowSegment (segments, show_segment)

#### Results

* [x] Show audio file link if result has audio file.
     I'd like to see a better way, but this will get us there for now.
     ```ruby
     <% if result.audio_url %>
       <%= link_to "Listen", result.audio_url %>
     <% end %>
     ```

Later iteration.

* [] Interface to play audio file from results page, instead of a link.

### Styling

* [] Style initial search page to match spec.
* [] Style results page header.
* [] Style results page results.
