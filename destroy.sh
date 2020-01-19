#!/bin/bash

docker kill pipeline

docker system prune -f
