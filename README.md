# data-science-template
## Set env

clone
```
git clone --recurse-submodules <git url>
```

build base docker image
```
cd docker-python
./build --gpu
```

run images
```
docker-compose up --build
```