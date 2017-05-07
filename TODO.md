== Needed ==
* rake task to check google and import photos
** email submitter with error if the subject line can't be parsed
** email admin if photos are not from a user with a team for this game (but still create user)

* admin interface to see unassigned users and assign their team

* admin interface to reject photos
** emails sender with rejection note

* turn action links into button styling

* leaderboard: display scores for each team

* slideshow all photos
* display task title, team with photos in slideshow

* admin interface to create new memberships

== Optional ==
* enforce maximum team size?
* enforce starts-at, don't allow showing missions beforehand
* enforce ends-at, show time remaining
* developer auth method for development
* bonus points by admin
** display bonuses in slideshow

==Future==
* Allow any admin to create and manage their own games
** when dealing with most things, admin is on game level rather than overall; can't muck with someone else's game
** set starting location
** email login info settable by game
* auto svg/pdf of printable mission list
* Allow downloading of all photos as zipfile
* drag-and-drop reordering mission priorities
* allow buying tickets to a game via Stripe
* teams have leaders?
** rename your team
** invite others via email to join the game (and your team)
* write to Google spreadsheet? read from Google spreadsheet? https://github.com/gimite/google-drive-ruby
* "test mission" for beginning of game?

