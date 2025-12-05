target "dashboard" {
  context = "."
  contexts = {
    nodejs_lts = "docker-image://node:24-alpine"
  }
  dockerfile = "container/Dockerfile"
}

