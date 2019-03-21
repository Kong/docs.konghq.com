workflow "Documentation" {
  on = "push"
  resolves = ["Build and Deploy Jekyll"]
}

action "Build and Deploy Jekyll" {
  uses = "kong/docs.konghq.com@master"
  secrets = ["GITHUB_TOKEN"]
}
