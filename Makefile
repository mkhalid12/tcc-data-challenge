.PHONY:  build-local run-local local-run-all-jobs stop-local-infra deploy-local-infra

build-local:
	docker build . --tag data-ingest:latest

run-local: build-local
	docker run --rm --name data-ingest  data-ingest:latest

stop-local-infra:
	docker compose -f docker-compose.yml down

deploy-local-infra:
	docker compose -f docker-compose.yml up -d


