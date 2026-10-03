// Deploy healthcheck'i (docker-compose.yml) shu yerga uradi — o'chirmang va auth/redirect qo'ymang.
// Faqat front tirikligini bildiradi, backend'ga bog'liq emas.
export function GET() {
  return Response.json({ status: "ok" });
}
