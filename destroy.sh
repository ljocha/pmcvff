#!/bin/bash

rm -rf work

docker kill pipeline

docker system prune -f
