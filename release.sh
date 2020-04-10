# release.sh

# Revert not commited changes
git checkout -- .

git fetch --tags

#Get current version from package.json
VERSION=$(node -p "require('./package.json').version")

#Increase minor version by 1
BRANCH=$(echo $VERSION | (IFS="."; read a b c && echo $a.$(($b+1)).0))

#Create new release version
git checkout -b $BRANCH

#Generate changelog file and tag name
npm run standard-version-release -- --release-as $BRANCH

#Push branch and all the tag refs
git push origin $BRANCH --follow-tags

