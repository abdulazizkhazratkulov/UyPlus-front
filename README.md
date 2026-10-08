# UyPilus — Front

Next.js 16 (App Router). Backend: [UyPlus-back](https://github.com/abdulazizkhazratkulov/UyPlus-back) (`/dashboard/v1`).

```bash
npm install
npm run dev     # http://localhost:3000
npm run lint
npm run build   # .next/standalone — Docker image shundan yig'iladi
```

## Deploy

| Branch | Server | Deploy |
| --- | --- | --- |
| `dev` | DEV server — http://46.8.176.92/ | push → avtomatik |
| `main` | PROD — keyinchalik, alohida server | hozircha yo'q |

`dev` ga push → GitHub Actions: **build** (lint → `docker build` → image `ghcr.io/abdulazizkhazratkulov/uypilus-front:<sha>` + `:dev`)
→ **deploy** (SSH: serverda `/opt/uypilus-front/.env` ga `APP_IMAGE`, `APP_ENV` yoziladi → `docker compose pull && up -d --wait web`).
Konteyner `127.0.0.1:13022` da, tashqariga nginx `location /` orqali chiqadi. `/dashboard/`, `/mobile/` — backend.

| Fayl | Vazifasi |
| --- | --- |
| `Dockerfile`, `.dockerignore` | Next.js standalone image (build image ichida, GitHub runner'da) |
| `docker-compose.yml` | Server stack: `web` konteyneri |
| `.github/workflows/deploy.yml` | CI/CD |
| `app/api/health/route.ts` | Konteyner healthcheck'i |

Deploy buzilmasligi uchun:

- `next.config.ts` dagi `output: "standalone"` va `app/api/health/route.ts` qolishi shart.
- `/dashboard/*` va `/mobile/*` yo'llari backend'niki (nginx) — front sahifalari bu prefikslarni ishlatmasin.
- `NEXT_PUBLIC_*` build vaqtida bundle'ga yoziladi: yangisini qo'shsangiz `Dockerfile` (`ARG`/`ENV`)
  va `deploy.yml` (`build-args`) ga ham qo'shing.

GitHub: **Settings → Secrets and variables → Actions**:

- **Secret:** `SERVER_SSH_KEY` — deploy kaliti (private key, base64)
- **Variables:** `SERVER_HOST` (`46.8.176.92`), `SERVER_USER`
- Ixtiyoriy variable: `SERVER_KNOWN_HOSTS` — server host kaliti (`ssh-keyscan -t ed25519 46.8.176.92`); bo'lmasa host tekshirilmaydi
- Ixtiyoriy variable: `NEXT_PUBLIC_API_URL` — bo'sh bo'lsa API so'rovlari shu domenning o'ziga (`/dashboard/v1`)

Server sozlamasi (nginx `location /`) — `UyPlus-back` dagi `docs/SERVER.md` da (repo'da emas).
