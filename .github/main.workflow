workflow "Build and deploy on push" {
  resolves = ["Build and Deploy Jekyll"]
  on = "push"
}

action "Build and Deploy Jekyll" {
  uses = "kong/docs.konghq.com@master"
  secrets = [
    "JEKYLL_Token",
  ]
  args = "branch master"
}
