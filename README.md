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

To run using the same method as will be run on heroku (including environment settings), run:
RACK_ENV=development PORT=3000 foreman start

To load up seed data
rake db:seed
(or to overwrite the seed data using the current db data, RAILS4=true WITHOUT_PROTECTION=false rake db:seed:dump)

