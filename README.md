This is a [Next.js](https://nextjs.org) project bootstrapped with [
`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically
optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Build

### Build container

A convenience script for building a container is provided that builds a container image containing the production build
in standalone mode. To build a container tagged `dpinterview:latest` and `dpinterview:$npm_package_version` with
npm_package_version taken from `package.json` run:

```shell
npm run build:container
# To set the image set container_name
export container_name=my.repo.example.org/dpinterview
npm run build:container
# You can adjust Buildx by passing args after a -- e.g. to build a Intel and ARM 64bit Linux images 
npm run build:container -- --platform linux/amd64,linux/arm64  
```

### Extra npm scripts

- `docker-compose`

    Convenience function for calling `docker compose`. Pass the compose command and parameters after a `--`.
   
    ```shell
    # Render config for current environment 
    npm run docker-compose -- config
    # Pull image
    npm run docker-compose -- pull
    # Access the last 5min of logs for the dashboard  
    npm run docker-compose -- logs ui --since 5m 
    ```

- `start:compose`

    Wrapper to start the compose file


## Run

### Docker Compose

There's a `docker-compose.yaml` for running the code. It defaults to using [Caddy](https://caddyserver.com/) to serve
files from the data volume and reverse proxy to the Next.js dashboard. The config for this available at
[conf/Caddyfile](conf/Caddyfile). As a minor optimisation the static assets for the dashboard are served by Caddy not
the Next.js server.

The assets from the internal data volume are served via a read-only mount local to the Caddy server's container
limiting  
access the wider system.

```mermaid
---
title: Docker Compose structure
---
flowchart TD
    Caddy -- reverse proxy --> next[Next.js]
    Caddy -- file serving --> static[Static Assets]
    next --> db[(AV Database)]
    Caddy -- file serving --> internal-storage("data volume")
```

### Config

The dashboard now takes only one environment variable

| Name         | example value                                   | Note                                                                     |
|--------------|-------------------------------------------------|--------------------------------------------------------------------------|
| DATABASE_URL | postgres://user:token@example.com:5432/database | see [here](https://node-postgres.com/features/connecting#connection-uri) | 

