#!/usr/bin/env sh

# shellcheck disable=SC2312

if [ -n "$(git status -s)" ]; then
  echo "The working directory is dirty. Please commit any pending changes."
  exit 1
fi

clean_tree() {
  echo "Deleting old publication"
  rm -rf public
  mkdir public

  git worktree prune
  rm -rf .git/worktrees/public/

  echo "Checking out gh-pages branch into public"
  git worktree add -B gh-pages public origin/gh-pages

  echo "Removing existing files"
  rm -rf public/*
  return 0
}

make_new() {
  echo "Generating site"
  env HUGO_ENV="production" hugo -t github-style --minify
  return 0
}

publish_site() {
  echo "Updating gh-pages branch"
  cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

  echo "Pushing to github"
  git push --all
  return 0
}

main() {
  clean_tree
  make_new
  publish_site
  exit 0
}

while true; do
  main "{@}"
done
