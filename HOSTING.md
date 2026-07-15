# Hosting Migration Notes (Heroku → Render / Fly.io)

Investigated 2026-07-14. Reference for when we upgrade/replace the Heroku setup.

## What ties this app to Heroku today

- **`Procfile`**: `web: bundle exec rails server -u thin -p $PORT -e $RACK_ENV` — portable, both platforms support a custom start command reading `$PORT`.
- **`wkhtmltopdf-heroku` gem** (Gemfile) — a Heroku-buildpack-specific binary wrapper for `wicked_pdf`. Needs to be swapped for `wkhtmltopdf-binary` (bundles the binary as a gem, works anywhere) or installed via a Dockerfile/apt.
- **No `Dockerfile`** — the app relies purely on Heroku's Ruby buildpack. Render supports native buildpack-style Ruby services (no Docker needed), so that path ports over almost as-is. Fly is Docker-first: `fly launch` can generate a Dockerfile automatically for a standard Rails app, but you'd own that Dockerfile going forward.
- **Heroku Postgres** — `config/database.yml` explicitly defers prod config to Heroku (`DATABASE_URL`). Both alternatives work the same way (env var), but you'd need to provision a new Postgres instance and migrate data via `pg_dump`/`pg_restore` (the `latest.dump` in the repo is a 31KB seed/sample dump, not prod data — actual prod data lives on Heroku and would need a fresh dump).
- **No scheduled jobs.** The app used to run `rake email:update_photos` on Heroku Scheduler to poll Gmail for emailed-in photos, but that submission path has been removed (photos are submitted directly from the phone browser). There is no longer any scheduled job to port, which removes what was the trickiest part of a Render/Fly migration.
- **~30 secrets in `.env`** (S3, Postmark, Stripe, Google, Gmail, `SECRET_KEY_BASE`, etc.) all need to be re-entered into the new platform's env/secrets UI.
- **Stripe webhook** (`app/controllers/stripe_webhooks_controller.rb`) — webhook URL in the Stripe dashboard must be repointed to the new domain once cut over.
- **Custom domain** `play.photoscavenger.com` — DNS repoint + new TLS cert (both platforms auto-issue certs, low effort).
- **Photo storage already on S3** via Paperclip (`config/environments/production.rb`) — no ephemeral-filesystem migration needed.
- **ActiveJob uses the default `:async` in-process adapter** (no Redis/Sidekiq despite the stray `RAILS_RESQUE_REDIS` env var, which looks unused) — nothing extra needed on either platform.

## Cost comparison (small single-web-dyno app + Postgres + one scheduled job)

| | Heroku (current-ish) | Render | Fly.io |
|---|---|---|---|
| Web | Eco $5 or Basic $7/mo | Starter $7/mo | shared-cpu-1x machine ~$2–5/mo |
| Postgres | Essential-0 $5/mo | Basic-256mb $6/mo | Self-hosted on volume ~$2–7/mo (practical prod: ~$7.20/mo) |
| **Total** | **~$10–12/mo** | **~$13/mo** | **~$5–12/mo** |

Fly's Managed Postgres is a separate, pricier option (Basic plan starts at $38/mo) — only self-hosted Postgres-on-a-volume gets Fly into the cheaper range shown above.

## Bottom line

- **Render** is basically cost-parity with Heroku (maybe slightly more) but is the easiest migration — same buildpack/Procfile mental model, native Postgres. Good choice if the goal is "get off Heroku" more than "save money."
- **Fly.io** is the one with real savings potential (roughly half), but it shifts more onto you: writing/maintaining a Dockerfile, and self-managing Postgres (backups, upgrades) unless you pay for Fly's Managed Postgres (which starts at $38/mo and erases the savings).
- Swapping `wkhtmltopdf-heroku` → `wkhtmltopdf-binary` is needed either way.

Given this is a small side-project app, leaning toward **Render** unless comfortable owning a Dockerfile and self-hosted Postgres for Fly's bigger discount.

## Migration checklist (when we do this)

- [ ] Swap `wkhtmltopdf-heroku` gem for `wkhtmltopdf-binary`
- [ ] (Fly only) Write/generate a `Dockerfile` via `fly launch`
- [ ] Provision new Postgres instance on target platform
- [ ] `pg_dump` prod data from Heroku, restore to new Postgres
- [ ] Copy all ~30 env vars from `.env`/Heroku config vars to new platform
- [ ] Update Stripe webhook URL to new domain
- [ ] Repoint DNS for `play.photoscavenger.com`, verify TLS cert issued
- [ ] Smoke test: game creation, photo submission from phone, Stripe checkout + webhook, PDF export
- [ ] Decommission Heroku app once verified
