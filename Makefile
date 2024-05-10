image=ljocha/pmcvff
version=2023-1


build:
	docker build -t $image:$version .
	docker push $image:$version
