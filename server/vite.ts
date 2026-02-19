import express, { type Express } from "express";
import fs from "fs";
import path from "path";
import { createServer as createViteServer, createLogger } from "vite";
import { type Server } from "http";
import viteConfig from "../vite.config";
import { nanoid } from "nanoid";
<<<<<<< HEAD
import { fileURLToPath } from "url";

/* ------------------ dirname fix (ESM safe) ------------------ */
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const viteLogger = createLogger();

/* ------------------ logger ------------------ */
=======

const viteLogger = createLogger();

>>>>>>> 04cd047bc13fb4f9141283d0051bba761fa59399
export function log(message: string, source = "express") {
  const formattedTime = new Date().toLocaleTimeString("en-US", {
    hour: "numeric",
    minute: "2-digit",
    second: "2-digit",
    hour12: true,
  });

  console.log(`${formattedTime} [${source}] ${message}`);
}

<<<<<<< HEAD
/* ------------------ DEV: Vite middleware ------------------ */
=======
>>>>>>> 04cd047bc13fb4f9141283d0051bba761fa59399
export async function setupVite(app: Express, server: Server) {
  const serverOptions = {
    middlewareMode: true,
    hmr: { server },
<<<<<<< HEAD
=======
    allowedHosts: true,
>>>>>>> 04cd047bc13fb4f9141283d0051bba761fa59399
  };

  const vite = await createViteServer({
    ...viteConfig,
    configFile: false,
    customLogger: {
      ...viteLogger,
      error: (msg, options) => {
        viteLogger.error(msg, options);
        process.exit(1);
      },
    },
    server: serverOptions,
    appType: "custom",
  });

  app.use(vite.middlewares);
<<<<<<< HEAD

  app.use("*", async (req, res, next) => {
    try {
      const url = req.originalUrl;

      const clientTemplate = path.resolve(
        __dirname,
        "..",
        "client",
        "index.html"
      );

      let template = await fs.promises.readFile(clientTemplate, "utf-8");

      template = template.replace(
        `/src/main.tsx`,
        `/src/main.tsx?v=${nanoid()}`
      );

      const html = await vite.transformIndexHtml(url, template);

      res.status(200).set({ "Content-Type": "text/html" }).end(html);
=======
  app.use("*", async (req, res, next) => {
    const url = req.originalUrl;

    try {
      const clientTemplate = path.resolve(
        import.meta.dirname,
        "..",
        "client",
        "index.html",
      );

      // always reload the index.html file from disk incase it changes
      let template = await fs.promises.readFile(clientTemplate, "utf-8");
      template = template.replace(
        `src="/src/main.tsx"`,
        `src="/src/main.tsx?v=${nanoid()}"`,
      );
      const page = await vite.transformIndexHtml(url, template);
      res.status(200).set({ "Content-Type": "text/html" }).end(page);
>>>>>>> 04cd047bc13fb4f9141283d0051bba761fa59399
    } catch (e) {
      vite.ssrFixStacktrace(e as Error);
      next(e);
    }
  });
}

<<<<<<< HEAD
/* ------------------ PROD: Serve static build ------------------ */
export function serveStatic(app: Express) {
  const distDir = path.resolve(__dirname, "..", "client", "dist");
  const indexHtml = path.join(distDir, "index.html");

  if (!fs.existsSync(indexHtml)) {
    throw new Error(
      `Build not found at ${indexHtml}. Run client build first.`
    );
  }

  app.use(express.static(distDir));

  app.use("*", (_req, res) => {
    res.sendFile(indexHtml);
=======
export function serveStatic(app: Express) {
  const distPath = path.resolve(import.meta.dirname, "public");

  if (!fs.existsSync(distPath)) {
    throw new Error(
      `Could not find the build directory: ${distPath}, make sure to build the client first`,
    );
  }

  app.use(express.static(distPath));

  // fall through to index.html if the file doesn't exist
  app.use("*", (_req, res) => {
    res.sendFile(path.resolve(distPath, "index.html"));
>>>>>>> 04cd047bc13fb4f9141283d0051bba761fa59399
  });
}
