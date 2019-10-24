#!/bin/bash

docker build -t pipeline:latest .

docker run -p 8888:8888 pipeline:latest
