== Important ==
* post-game directions better: for organizer, zip file and leaderboard and slideshow
(still allowing for future games)

* Test coverage
** register before a game starts
** register while a game is in progress

* don't allow blank team names (and provide a good error)

* remove old games (more than a month old) and/or back up to cold storage

== Desired ==
* google calendar event with 1-day and 1-hour email reminder

* Allow test photo uploads before the game begins

* Day-before reminder for people with teams

* Day-before reminder for people without teams

* get rid of min/max team size
** maybe just a warning note when the 6th-or-more person signs up for a team?

* Add spec for uploading photo (form still doesn't submit in spec)

* Add spec for reordering missions

* easier mission creation/management (including mission import from templates or other games)
** template categories: standard, risque, geeky, sporty, science, non-players, boston, san francisco, families, etc.

* Select icons for missions from the noun project
** https://github.com/TailorBrands/noun-project-api

* shortname stubs for game and team (specifically for invite links)

* Automatically increase server capacity during a game, decrease after it ends
** http://blog.leshill.org/blog/2011/04/03/using-resque-and-resque-scheduler-on-heroku.html
** rake task, run every 10m using heroku: check if game has started/ended since last check, if so, update scheduler on/off and scale other workers up/down
** also automatically make zip file and post-game email for participants

* Make it pretty

* Make it responsive

* eventbrite integration?

* timezone from lat/long happens via ajax to json ednpoint and setting selector, rather than reload

* amplitude logging

* server health monitoring

== Optional ==
* teams have leaders?
** can set whether team needs approval to join
** emailed when someone requests to join
** approve people to join team, remove people from team

* email updater can deal with more than one game running simultaneously

* check normalized team name on input for similarity to others, suggest "did you mean?"

* Review discussion
** admin can send questions rather than rejecting photos
** team sees those questions at the top of /play
** team gets emailed this
** email responses are automatically picked up
** admin can resolve comments
** admin can deny points (marked as such in slideshow) without rejecting

* bonus points by admin
** display bonuses in slideshow
* auto svg/pdf of printable mission list
** when generating, enforce unique mission identifiers per game
* developer auth method for development
* eventual archiving of games (only store the zip file, redirect people looking for that game)

== Monetization ==
* Pricing: per-event, not subscription (organizers run 1-2 hunts/year; high intent + budget at organize time, but a subscription would just churn)
** Free tier: up to ~10 players, branded/watermarked experience -- this is the marketing engine, not lost revenue
** Party tier, ~$39/event: up to ~30 players, for bachelorette/birthday/reunion use cases
** Team tier, ~$199/event: unlimited players, custom branding on slideshow/leaderboard, mission template packs -- corporate HR is the buyer, don't underprice
** Let organizers build the whole game for free (teams, missions, invites) and only pay to launch -- highest conversion point, since they've already invested effort and invited people
** Implement with Stripe Checkout gate on "start game" (ties into existing "Price: allow buying tickets to a game via Stripe" item above)

* Product prep needed before charging money
** Always-on hosting -- can't keep asking Thomas to manually restart heroku once customers are paying
** DONE: Direct phone-browser photo upload is now the only submission path; the fragile email-in/resque polling path has been removed
** Paperclip -> ActiveStorage migration (already on TODO above) -- unmaintained gem, fine for hobby, not for paid product
** Mission template packs (already on TODO above: standard, risque, geeky, sporty, science, city-specific, etc.) -- biggest value-add, since the real organizer cost is writing 20 good missions, not money

* Marketing, ranked by return per hour of effort
** Built-in viral loop: add "Run your own hunt" CTA to slideshow, leaderboard, and post-game photo-zip email -- one-time product change, compounds forever since every game exposes it to 10-50 people at the most fun moment
** Evergreen SEO pages: publish mission template lists as free public pages ("50 office scavenger hunt missions", "bachelorette photo hunt ideas") with a "run this hunt automatically" button -- weekend of writing, then unattended; likely source of corporate buyers
** Directory listings: team-building tool roundups/listicles, Capterra -- a few hours, one-time
** One launch spike: Show HN / Product Hunt post to seed first cohort
** Skip: paid ads, social media presence, cold outreach, custom enterprise deals -- all require ongoing effort to not lose money/time

* Realistic expectations: $199 corporate tier at 3-8 sales/month = $600-1,600/month, plausible within 6-12 months if SEO pages rank and viral loop is in place. $39 party tier alone won't get there (needs 30+/month) -- treat B2C as viral seed, corporate as the actual revenue.

==Future==
* write to Google spreadsheet? read from Google spreadsheet? https://github.com/gimite/google-drive-ruby
* group missions into sections/themes
* check photo metadata to look for submitted photos taken before the game
* ability for players to vote on photos (time after game ends)
* graph of team points positions over time
* rules provided as actual pdf