== Needed ==
* user can join a team (or create a new one)
* user can change teams
* individuals can enter a team name
* individuals can add others to their team
** error if that person is already on another team; otherwise it adds them (creating if needed)

* s3 storage of photos
** user can upload photo from webpage, have it automatically associated with team

* rake task to check google and import photos
** email login info settable by game
** email admin if photos cannot be assigned to a team

* admin interface to see unassigned users/photos and assign their team

* admin interface to reject photos
** emails sender with rejection note

* interface to list your team's tasks
** optional filter to just unaccomplished tasks
** can submit/upload photo through interface

* slideshow all photos

Game
- admin
Team
- game
- name
Player
- team
- email address
Task
- Game
Photo
- Player
- Team (optional, for failed assignments)
- Task (optional, for failed assignments)
- photo content
- state

== Optional ==
* display task title, team with photos in slideshow
* enforce ends-at, show time remaining
* display scores and fulfilment for each team
* developer auth method for development
* bonus points by admin
** display bonuses in slideshow

==Future==
* Allow any admin to create and manage games
** when dealing with most things, admin is on game level rather than overall; can't muck with someone else's game
* Allow downloading of all photos as zipfile

