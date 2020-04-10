# patch-release.sh

git fetch

patching()
{
  git checkout $1
  echo  Patching...

  # similar as for release.sh
  VERSION=$(node -p "require('./package.json').version")
  BRANCH=$(echo $VERSION | (IFS="."; read a b c && echo $a.$b.$(($c+1))))
  git checkout -b $BRANCH

  #Cherry pick commits announced in `patch-config.json`
  for i in $(jq '.commits | .[]'  ./patch-config.json); do
    COMMIT=$(echo $i | xargs)
    echo $COMMIT
    git cherry-pick $COMMIT --strategy-option theirs
    git add .
    git commit -a
  done

  # Generate changelog
  npm run standard-version-release -- --release-as $BRANCH

  # push patch branch to git repo with tag
  git push --set-upstream origin $BRANCH --follow-tags
}

#Create patch per each branch announced in `patch-config.json`
for i in $(jq '.releases | .[]'  ./patch-config.json); do
  BRANCH=$(echo $i | xargs)
  patching $BRANCH
done

