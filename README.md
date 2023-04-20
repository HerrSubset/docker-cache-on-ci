Build initial image and push it to Docker Hub
```
docker build -t herrsubset/docker-cache-on-ci:broken-cache .
docker push herrsubset/docker-cache-on-ci:broken-cache
```

Re-run the build and see that everything is cached.
```
docker build -t herrsubset/docker-cache-on-ci:broken-cache .
docker push herrsubset/docker-cache-on-ci:broken-cache
```

Clear the cache, pull the image and see if you hit any cache.
```
docker images | 
    grep docker-cache-on-ci | 
    awk '{ print $3 }' | 
    xargs docker rmi -f && 
    docker system prune -f
docker pull herrsubset/docker-cache-on-ci:broken-cache
docker build -t herrsubset/docker-cache-on-ci:cache-miss
```

Clear the cache and rebuild the image, this time with layer cache info included.
```
docker images | 
    grep docker-cache-on-ci | 
    awk '{ print $3 }' | 
    xargs docker rmi -f && 
    docker system prune -f
DOCKER_BUILDKIT=1 docker build --tag herrsubset/docker-cache-on-ci:working-cache --build-arg BUILDKIT_INLINE_CACHE=1 .
```

Rebuild with the --cache-from flag. See that all layers are cached.
First time will pull the image, but if it's present that's also skipped.
```
DOCKER_BUILDKIT=1 docker build --tag herrsubset/docker-cache-on-ci:working-cache --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from herrsubset/docker-cache-on-ci:working-cache .
```
