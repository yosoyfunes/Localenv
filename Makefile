# Usage:
# make        # compile all binary
# make clean  # remove ALL binaries and objects

.PHONY = all

MK_ARGS = $(TARGET)
MK_BIN ?= docker

# check-env:
#   ifndef ENV
#     $(error ENV is undefined. Use 'ENV=<env>' <env> is environments)
#   endif

all:
	@echo "example: ENV='env-tets' make build TARGET='--no-cache' its the same that: docker build --no-cache -e env-test"

push:	
	@echo "push image to registry"
	$(MK_BIN) push yosoyfunes/cbff-local $(MK_ARGS)

build:
	@echo "build image Docker from Dockerfile"
	$(MK_BIN) build . --no-cache -t yosoyfunes/cbff-local $(MK_ARGS)
