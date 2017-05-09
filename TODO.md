== Desired ==
* add denormalized team_id to photos? (and update a user's photos when a user gets a new team?)
** use in slideshow, leaderboard, game.make_zip_file

== Optional ==
* developer auth method for development
* bonus points by admin
** display bonuses in slideshow
* enforce unique mission identifiers per game (priority numbers; rename to id numbers)

==Future==
* Make it pretty
* Test coverage
* Multi-game
* Allow any admin to create and manage their own games
** when dealing with most things, admin is on game level rather than overall; can't muck with someone else's game
** set starting location
** email login info settable by game
** easier mission management
* auto svg/pdf of printable mission list
* allow buying tickets to a game via Stripe
* teams have leaders?
* enforce maximum team size?
** rename your team
** invite others via email to join the game (and your team)
* write to Google spreadsheet? read from Google spreadsheet? https://github.com/gimite/google-drive-ruby
* group missions into sections/themes
* check photo metadata to look for previously-taken photos