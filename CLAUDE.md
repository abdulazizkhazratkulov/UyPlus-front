@AGENTS.md

# UyPilus Front

- Ish branch'i — `dev`: push → DEV serverga avtomatik deploy (`README.md` → "Deploy"). `main` — keyinchalik PROD.
- Buzmang: `next.config.ts` dagi `output: "standalone"` va `app/api/health/route.ts` (konteyner healthcheck'i).
- `/dashboard/*`, `/mobile/*` — backend yo'llari (nginx). Front sahifalari bu prefikslarni ishlatmasin.
- `NEXT_PUBLIC_*` build vaqtida bundle'ga yoziladi — yangisi `Dockerfile` (`ARG`/`ENV`) va `deploy.yml` (`build-args`) ga ham qo'shiladi.
- Commit'dan oldin: `npm run lint && npm run build`.
