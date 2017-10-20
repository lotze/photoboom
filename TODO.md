== Important ==
* Test coverage
** emailed photos from non-registered email; (organizer is emailed, can assign person even if not registered)
** register

* better way to deal with unregistered emails coming in
** figure out why resque job isn't processing emails at all in staging -- ah! just needs a scheduler running?

* don't allow blank team names (and provide a good error)

== Desired ==
* google calendar event with 1-day and 1-hour email reminder

* Allow test photo uploads before the game begins

* Day-before reminder for people with teams

* Day-before reminder for people without teams

* get rid of min/max team size
** maybe just a warning note when the 6th-or-more person signs up for a team?

* Add spec for uploading photo (form still doesn't submit in spec)

* Add spec for emailed photos

* Add spec for reordering missions

* Price: allow buying tickets to a game via Stripe

* easier mission creation/management (including mission import from templates or other games)
** template categories: standard, risque, geeky, sporty, science, non-players, boston, san francisco, etc.

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

==Future==
* write to Google spreadsheet? read from Google spreadsheet? https://github.com/gimite/google-drive-ruby
* group missions into sections/themes
* check photo metadata to look for submitted photos taken before the game
* ability for players to vote on photos (time after game ends)
* graph of team points positions over time
* rules provided as actual pdf