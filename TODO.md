== Needed ==
* interface to list your team's tasks
** optional filter to just unaccomplished tasks
** can submit/upload photo through interface

* s3 storage of photos
** user can upload photo from webpage, have it automatically associated with team

* rake task to check google and import photos
** email login info settable by game
** email admin if photos cannot be assigned to a team

* admin interface to see unassigned users/photos and assign their team

* admin interface to reject photos
** emails sender with rejection note

* slideshow all photos

== Optional ==
* enforce maximum team size?
* display task title, team with photos in slideshow
* enforce starts-at, don't allow showing missions beforehand
* enforce ends-at, show time remaining
* leaderboard: display scores for each team
* developer auth method for development
* bonus points by admin
** display bonuses in slideshow

==Future==
* Allow any admin to create and manage their own games
** when dealing with most things, admin is on game level rather than overall; can't muck with someone else's game
** set starting location
* auto svg/pdf of printable mission list
* Allow downloading of all photos as zipfile
* drag-and-drop reordering mission priorities
* allow buying tickets to a game via Stripe
* teams have leaders?
** rename your team
** invite others via email to join the game (and your team)
