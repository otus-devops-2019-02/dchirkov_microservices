USERNAME=daryan

build_all: build_ui build_post build_comment build_prometheus build_mongodb_exporter
push_all: push_ui push_post push_comment push_prometheus push_mongodb_exporter

build_ui: ../src/ui/Dockerfile
	cd ../src/ui/ && ./docker_build.sh

build_post: ../src/post-py/Dockerfile
	cd ../src/post-py/ && ./docker_build.sh

build_comment: ../src/comment/Dockerfile
	cd ../src/comment/ && ./docker_build.sh

build_prometheus: ../monitoring/prometheus/Dockerfile
	docker build -t $(USERNAME)/prometheus ../monitoring/prometheus

build_mongodb_exporter:
	rm -rf /tmp/mongodb_exporter && cd /tmp && git clone https://github.com/percona/mongodb_exporter.git
	cd /tmp/mongodb_exporter && make docker DOCKER_IMAGE_NAME="$(USERNAME)/mongodb-exporter" DOCKER_IMAGE_TAG="latest"

push_ui:
	docker push $(USERNAME)/ui

push_post:
	docker push $(USERNAME)/post

push_comment:
	docker push $(USERNAME)/comment

push_prometheus:
	docker push $(USERNAME)/prometheus

push_mongodb_exporter:
	docker push $(USERNAME)/mongodb-exporter

.PHONY: build_all push_all