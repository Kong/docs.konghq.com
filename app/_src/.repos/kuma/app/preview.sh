: "${BRANCH:=master}"
: "${REPO:=kumahq/kuma}"

if [[ ! -x `which gh` ]]; then 
  echo "You must have github's gh client installed to use this tool"
  exit 1
fi

IFS=/ read -r owner repo << EOF
${REPO}
EOF

JQCMD='.data.repository.ref.target.history.nodes | map(select(.statusCheckRollup.state == "SUCCESS")) | first | .oid'
COMMIT=`gh api graphql  -f owner=${owner} -f repo=${repo} -f branch=${BRANCH} --jq "${JQCMD}" -F query='
query($owner: String!, $repo: String!, $branch: String!) {
  repository(owner: $owner, name:$repo) {
    ref(qualifiedName: $branch) {
        target{
          ... on Commit {
          history(first: 10){
            nodes{
              oid
              statusCheckRollup {
                state
              }
            }
         }
        }
       }
     }
  }
}
'`

echo "Getting release $VERSION"

if [ $REPO == "kong/kong-mesh" ]; then
  PRODUCT_NAME="KONG MESH"
  REPO_PREFIX="kong-mesh"
  COMMIT=${COMMIT:0:7}
else
  COMMIT=${COMMIT:0:9}
fi
VERSION=0.0.0-preview.v${COMMIT}

curl -s https://kuma.io/installer.sh | PRODUCT_NAME=${PRODUCT_NAME} REPO_PREFIX=${REPO_PREFIX} VERSION=${VERSION} sh -