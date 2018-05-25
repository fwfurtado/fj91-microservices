help:
	@ echo "Projects: authors, books, books-shop"
	@ echo
	@ echo "If don't specify a project the target will running for all projects. (except log target)"
	@ echo
	@ echo "package project=<project>"
	@ echo "up project=<project>"
	@ echo "down project=<project>"
	@ echo "log project=<project>"
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
else
	@ make _package/$(project)
endif


up:
ifeq "$(project)" "all"
	@ make _up/authors project=authors
	@ make _up/books project=books
	@ make _up/books-shop project=books-shop
else
	@ make _up/$(project)
endif

down:
ifeq "$(project)" "all"
	@ make _down/authors project=authors
	@ make _down/books project=books
	@ make _down/books-shop project=books-shop
else
	@ make _down/$(project)
endif


#####################
# Executions indeed #
#####################
log:
	less +F $(project).out

_package/$(project):
	@ echo "Trying to package $(project) project(s)"
	@ mvn clean package -pl $(project) && rm -f $(project).out

_up/$(project): _package/$(project)
	@ echo "Starting project $(project)"
	@ nohup java -jar $(project)/target/*.jar &> $(project).out&

_down/$(project):
	@ echo "Stop project $(project)"
	@ jps | grep "$(project)-.*\.jar" | cut -f 1 -d ' ' | xargs kill -9


