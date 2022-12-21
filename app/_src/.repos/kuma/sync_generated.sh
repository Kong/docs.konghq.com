#!/bin/bash
set -e

function os_agnostic_sed() {
  if [[ "$(go env GOOS)" == "darwin" ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

pushd ../kuma

for remote in $(git remote); do
    url=$(git remote get-url "$remote")
    if [[ "$url" =~ .*kumahq/kuma$ ]]; then
        kumahq="$remote"
    fi
done

git fetch "$kumahq"

popd

for i in app/docs/*; do
  if [[ ! -d $i ]]; then continue; fi

  branch=$(basename "$i" | sed 's/\(.*\)\.x/release-\1/g')
  if [[ $branch == "dev" ]]; then
    branch="master"
  fi
  echo "Copying $branch"

  pushd ../kuma
    git checkout "$kumahq/$branch"
  popd
  if [[ ! -d ../kuma/docs/generated ]]; then
    echo "No generated docs, ignoring..."
    continue
  fi
  echo "Copying generated docs"
  rm -rf "${i}/generated"
  cp -r ../kuma/docs/generated "${i}/generated"
  if [[ -f ../kuma/pkg/config/app/kuma-cp/kuma-cp.defaults.yaml ]]; then
    echo "Copying default"

    echo '# Control-Plane configuration
Here are all options to configure the control-plane:

```yaml' > "${i}/generated/kuma-cp.md"
    cat ../kuma/pkg/config/app/kuma-cp/kuma-cp.defaults.yaml >> "${i}/generated/kuma-cp.md"
    echo '```' >> "${i}/generated/kuma-cp.md"
  fi
  # Modify generated docs to have a valid format for the website
  # shellcheck disable=SC2044
  for j in $(find "${i}/generated" -name '*.md'); do
    # Make frontmatter titles
    os_agnostic_sed -E '1,1 s/^##? (.*)$/---\ntitle: \1\n---/' "${j}"
    if [[ "$j" =~ .*/cmd/.* ]]; then
      # Fix links
      path=$(dirname $j | sed -E 's|.*(/generated.*)|/docs/{{ page.version }}\1|')
      os_agnostic_sed -E 's|\((.*).md\)|('"$path"'/\1)|'  "${j}"
    fi
  done

done
