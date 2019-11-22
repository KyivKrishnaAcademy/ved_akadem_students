build_by_tag_and_dir () {
  local main_tag="$1/$2"
  local timestamped_tag="$main_tag:$(date '+%Y%m%d%H%M')"

  docker build $5 -t $main_tag -t $timestamped_tag -f $3 $4

  docker push $timestamped_tag
  docker push "${main_tag}:latest"
  docker image prune -f
}
