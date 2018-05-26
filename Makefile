help:
	@ echo "Projects: authors, books, books-shop, service-discovery"
	@ echo
	@ echo "If don't specify a project the target will running for all projects. (except log target)"
	@ echo
	@ echo "package project=<project>"
	@ echo "log service=<service name>"
	@ echo "up"
	@ echo "down"
	@ echo

project ?= all

######################
# Wrapped Executions #
######################
package:
ifeq "$(project)" "all"
	@ make _package/authors project=authors
	@ make _package/books project=books
	@ make _package/books-shop project=books-shop
	@ make _package/service-discovery project=service-discovery
else
	@ make _package/$(project)
endif

#
#up:
#ifeq "$(project)" "all"
#	@ make _up/authors project=authors
#	@ make _up/books project=books
#	@ make _up/books-shop project=books-shop
#	@ make _up/books-shop project=service-discovery
#else
#	@ make _up/$(project)
#endif
#
#down:
#ifeq "$(project)" "all"
#	@ make _down/authors project=authors
#	@ make _down/books project=books
#	@ make _down/books-shop project=books-shop
#	@ make _down/books-shop project=service-discovery
#else
#	@ make _down/$(project)
#endif


#####################
# Executions indeed #
#####################
log:
	docker-compose logs -f $(service)

_package/$(project):
	@ docker rmi -f microservice-$(project)
	@ echo "Trying to package $(project) project(s)"
	@ mvn clean package -pl $(project) && rm -f $(project).out

#_up/$(project): _package/$(project)
#	@ echo "Starting project $(project)"
#	@ nohup java -jar $(project)/target/*.jar &> $(project).out&
#
#_down/$(project):
#	@ echo "Stop project $(project)"
#	@ jps | grep "$(project)-.*\.jar" | cut -f 1 -d ' ' | xargs kill -9


up: package
	@ docker-compose up -d
	@ sleep 10

down:
	@ docker-compose stop && docker-compose rm -vf
	@ rm -f ./service-discovery/nginx/config/loadbalance/*.conf