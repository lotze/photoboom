== Test ==

== Important ==
* more game management
** easier mission management (including mission import from templates or other games)

* registration restrictions
** price: allow buying tickets to a game via Stripe
** participants need to affirm a waiver

* Email checks every 20 seconds

* Uploading UI improvements
** javascript: 'uploading' spinner while uploading, until successful/failed
** display better upload confirmation

* Review queue: photos not yet reviewed (approved or not)
** admin can deny points (marked as such in slideshow) without rejecting
** admin can send questions rather than rejecting photos
** admin can un-reject rejected photos
** team sees those questions at the top of /play
** team gets emailed this
** email responses are automatically picked up
** admin can resolve comments

* Test coverage

* Change domain/email (configurable, use help@domain and photos@domain by default)

== Desired ==
* Allow test photo uploads before the game begins
* Automatically increase server capacity during a game, decrease after it ends
* Redo routes to be nested
* Emails sent using ActiveJob/Resque
* Make it pretty
* Make it responsive

== Optional ==
* teams have leaders?
** can set whether team needs approval to join
** emailed when someone requests to join
** approve people to join team, remove people from team

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