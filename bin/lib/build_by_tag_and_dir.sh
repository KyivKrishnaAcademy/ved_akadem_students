build_by_tag_and_dir () {
  main_tag="$1/$2"
  with_timestamp="$main_tag:$3"

  docker build -t "$main_tag" -t "$with_timestamp" "docker/$2"
  docker push "$with_timestamp"
  docker push "$main_tag:latest"
}
