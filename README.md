photoboom
=========

A rails server for the photo scavenger game "photoboom"

It is set up to use heroku, so stores secrets in environment variables (kept in .env, which is not checked in to the repo).  Environment variables required are:
SECRET_KEY_BASE
GOOGLE_KEY
GOOGLE_SECRET

It stores photos in S3 using paperclip, so you will need to set the following variables with your S3 information in production:
S3_BUCKET_NAME
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION

To run the rake task to check a gmail account and download emailed photos, you will need to set
GMAIL_LOGIN
GMAIL_PASSWORD

To specify the email game players should send their photos to, you should set
PHOTO_SUBMIT_EMAIL
and to specify the email for admin issues, set
ADMIN_EMAIL

To run using the same method as will be run on heroku (including environment settings), run:
RACK_ENV=development PORT=3000 foreman start

To load up seed data
rake db:seed
(or to overwrite the seed data using the current db data, RAILS4=true WITHOUT_PROTECTION=false rake db:seed:dump)

Instructions For Users
======================
Create event
Get people to sign up and make teams
(maybe export past missions)
Add missions
Start game
Review photos as they come in: /games/:id/admin_review
Finish the game
* Leaderboard
* Slideshow
You can see all the photos as a slideshow (with mission and team) at https://play.photoscavenger.com/slideshow?game_id=2
The leaderboard and a link to download all the photos from the hunt is at https://play.photoscavenger.com/leaderboard?game_id=2