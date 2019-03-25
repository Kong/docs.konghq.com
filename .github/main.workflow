workflow "Deploy Site" {
  on = "push"
  resolves = "levfishbluefish/jekyll-deploy-gh-pages@master"
}

action "Filters for GitHub Actions" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
  args = "branch master"
}

action "levfishbluefish/jekyll-deploy-gh-pages@master" {
  uses = "levfishbluefish/jekyll-deploy-gh-pages@master"
  needs = ["Filters for GitHub Actions"]
  args = "branch master"
  secrets = ["GITHUB_TOKEN"]
}
