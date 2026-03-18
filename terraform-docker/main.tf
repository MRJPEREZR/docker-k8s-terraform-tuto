resource "docker_network" "backend_network" {
  name   = "back-tier"
  driver = "bridge"
}

resource "docker_network" "frontend_network" {
  name   = "front-tier"
  driver = "bridge"
}

resource "docker_volume" "volume" {
  name = "db-data"
}

resource "docker_image" "redis_image" {
  name = "redis:alpine"
}

resource "docker_image" "postgresql_image" {
  name = "postgres:15-alpine"
}

resource "docker_image" "vote_image" {
  name = "vote:latest"
  build {
    context    = abspath("${path.root}/../vote")
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "nginx_image" {
  name = "nginx:latest"
  build {
    context    = abspath("${path.root}/../nginx")
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "result_image" {
  name = "result:latest"
  build {
    context    = abspath("${path.root}/../result")
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "seed_image" {
  name = "seed:latest"
  build {
    context    = abspath("${path.root}/../seed-data")
    dockerfile = "Dockerfile"
  }
}

resource "docker_image" "worker_image" {
  name = "worker:latest"
  build {
    context    = abspath("${path.root}/../worker")
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "redis_container" {
  name  = "redis"
  image = docker_image.redis_image.name
  healthcheck {
    test         = ["CMD", "/healthchecks/redis.sh"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 3
    start_period = "10s"
  }
  networks_advanced {
    name = docker_network.backend_network.name
  }
  volumes {
    container_path = "/healthchecks"
    host_path      = abspath("${path.root}/../../healthchecks")
  }
}

resource "docker_container" "postgresql_container" {
  name  = "db"
  image = docker_image.postgresql_image.name
  healthcheck {
    test         = ["CMD", "/healthchecks/postgres.sh"]
    interval     = "10s"
    timeout      = "10s"
    retries      = 3
    start_period = "10s"
  }
  networks_advanced {
    name = docker_network.backend_network.name
  }
  volumes {
    container_path = "/healthchecks"
    host_path      = abspath("${path.root}/../../healthchecks")
  }
  volumes  {
    volume_name    = docker_volume.volume.name
    container_path = "/var/lib/postgresql/data"
  }
  env = [
    "POSTGRES_PASSWORD=postgres",
    "POSTGRES_USER=postgres"
  ]
}

resource "docker_container" "vote1_container" {
  depends_on = [ docker_container.redis_container ]
  name = "vote-1"
  image = docker_image.vote_image.name
  ports {
    internal = 5000
    external = 80
  }
  networks_advanced {
    name = docker_network.backend_network.name
  }
  networks_advanced {
    name = docker_network.frontend_network.name
  }
}

resource "docker_container" "vote2_container" {
  depends_on = [ docker_container.redis_container ]
  name = "vote-2"
  image = docker_image.vote_image.name
  ports {
    internal = 5000
    external = 81
  }
  networks_advanced {
    name = docker_network.backend_network.name
  }
  networks_advanced {
    name = docker_network.frontend_network.name
  }
}

resource "docker_container" "nginx_container" {
  depends_on = [ docker_container.vote1_container, docker_container.vote2_container ]
  name = "nginx"
  image = docker_image.nginx_image.name
  ports {
    internal = 80
    external = 8000
  }
  networks_advanced {
    name = docker_network.frontend_network.name
  }
}

resource "docker_container" "result_container" {
  depends_on = [ docker_container.postgresql_container ]
  name = "result"
  image = docker_image.result_image.name
  ports {
    internal = 4000
    external = 4000
  }
  networks_advanced {
    name = docker_network.frontend_network.name
  }
  networks_advanced {
    name = docker_network.backend_network.name
  }
}

resource "docker_container" "seed_container" {
  depends_on = [ docker_container.nginx_container ]
  name = "seed"
  image = docker_image.seed_image.name
  networks_advanced {
    name = docker_network.frontend_network.name
  }
}

resource "docker_container" "worker_container" {
  depends_on = [ docker_container.postgresql_container ]
  name = "worker"
  image = docker_image.worker_image.name
  networks_advanced {
    name = docker_network.backend_network.name
  }
}