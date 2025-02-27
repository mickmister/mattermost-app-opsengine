NPM ?= npm

.PHONY: run-server stop-server restart-server build dist watch clean help

## run-server: starts the server.
run-server:
		@echo Running mattermost for development
		./run-server.sh

## stop-server: stops the server
stop-server:
		@echo Stopping mattermost for development
		./stop-server.sh

## restart-server: restarts the server.
restart-server:
		@echo Stopping mattermost for development
		./stop-server.sh
		@echo Running mattermost for development
		./run-server.sh

## build: build the app
build: node_modules
	$(NPM) run build

## dist: creates the bundle file
dist-aws: build
	rm -rf aws/$(app_id) && mkdir -p aws/$(app_id)
	mv dist/* aws/$(app_id)
	mv node_modules aws/$(app_id)
	cp -r src/locales aws/$(app_id)
	rm -r dist
	cp src/manifest.json aws
	cp -r static aws
	cd aws ; \
		zip -rm $(app_id).zip $(app_id) ; \
		zip -rm ../$(app_id).zip manifest.json static $(app_id).zip
	rm -r aws
## build: build the app when changed
watch: node_modules
	$(NPM) run build:watch

## clean: deletes all
clean:
	$(NPM) run clean

## node_modules: ensures NPM dependencies are installed without having to run this all the time
node_modules: $(wildcard package.json)
	$(NPM) install
	touch $@

help: ## help: prints this help message
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'