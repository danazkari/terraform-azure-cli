VERSION ?= $(shell git rev-parse --short HEAD)

build-docker: Dockerfile
	@docker build \
		-t danazkari/terraform-azure-cli:$(VERSION) \
		-t danazkari/terraform-azure-cli:latest \
		.

publish-docker: build-docker Dockerfile
	@docker push danazkari/terraform-azure-cli:$(VERSION)
	@docker push danazkari/terraform-azure-cli:latest
