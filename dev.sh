#! /bin/sh
exec docker run -it --rm \
  -v "$PWD/dist":/app/dist \
  -v "$PWD/app":/app/app  \
  -v "$PWD/package.json":/app/package.json \
  -v "$PWD/config":/app/config \
  -v "$PWD/tests":/app/tests \
  etms-frontend 
