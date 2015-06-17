NAME               := visualphoenix/pandoc
VERSION            := 1.14.0.4
PACKAGE_VERSION    := 3202287
REPOSITORY         := index.docker.io
BUILD_FILES        += $(filter-out $(wildcard target/*) $(wildcard target/**/*), $(wildcard **/*))
#$(info pkg: $$BUILD_FILES is [${BUILD_FILES}])
