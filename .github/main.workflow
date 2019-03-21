workflow "Jekyll build now" {
  resolves = [
    "Jekyll Action",
  ]
  on = "push"
}

action "Jekyll Action" {
  uses = "kong/docs.konghq.com@master"
  needs = "Filters for GitHub Actions"
  env = {
    SRC = "dist"
  }
  secrets = ["JEKYLL_Token"]
}

action "Filters for GitHub Actions" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
  args = "branch master"
}
