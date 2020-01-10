all: build

build:
	docker-compose build

prod:
	git checkout master
	git pull origin master
	$(MAKE) build

deploy_prod:
	ssh -A ubuntu@shaneburkhart.com "cd ~/SparkSchoolCourses; make prod;"
