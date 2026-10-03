import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Docker image uchun (CI/CD): .next/standalone — node_modules'siz ishlaydigan minimal server.js.
  output: "standalone",
};

export default nextConfig;
