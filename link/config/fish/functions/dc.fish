function dc
  echo "Removing containers"
  docker rm -f (docker ps -qa) 2>/dev/null
  echo "Removing untagged images"
  docker rmi (docker images | grep '<none>' | awk '{print $3}') 2>/dev/null
  echo "Removing networks"
  docker network rm (docker network ls | grep -Ev 'bridge\s+bridge|host|null|NETWORK' | awk '{print $1}') 2>/dev/null
end
