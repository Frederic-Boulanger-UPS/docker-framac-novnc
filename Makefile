.PHONY: build manifest buildfat check run debug push save clean clobber archi opt-opam z3 eprover souffle

REPO    = fredblgr/
NAME    = framac-novnc
#ARCH    = `uname -m`
TAG     = 2022
ARCH   := $(shell if [ `uname -m` = "x86_64" ]; then echo "amd64"; elif [ `uname -m` = "aarch64" ]; then echo "arm64"; else echo `uname -m`; fi)
RESOL   = 1440x900
ARCHS   = amd64 arm64
IMAGES := $(ARCHS:%=$(REPO)$(NAME):$(TAG)-%)
PLATFORMS := $$(first="True"; for a in $(ARCHS); do if [[ $$first == "True" ]]; then printf "linux/%s" $$a; first="False"; else printf ",linux/%s" $$a; fi; done)
SCRIPTS := build_scripts
BINARIES := binaries

help:
	@echo "# Available targets:"
	@echo "#   - build: build docker image"
	@echo "#   - clean: clean docker build cache"
	@echo "#   - run: run docker container"
	@echo "#   - push: push docker image to docker hub"

# Build image
build: $(BINARIES)/opt-opam_$(ARCH).tgz $(BINARIES)/z3_$(ARCH) $(BINARIES)/eprover_$(ARCH) $(BINARIES)/souffle_$(ARCH).tgz
	docker build --build-arg arch=$(ARCH) --build-arg bindir=$(BINARIES) --tag $(REPO)$(NAME):$(TAG)-$(ARCH) .
	@danglingimages=$$(docker images --filter "dangling=true" -q); \
	if [[ $$danglingimages != "" ]]; then \
	  docker rmi $$(docker images --filter "dangling=true" -q); \
	fi

# Build binaries with opam (requires privileged mode)
opt-opam: $(BINARIES)/opt-opam_$(ARCH).tgz

$(BINARIES)/opt-opam_$(ARCH).tgz:
	echo "sh /workspace/$(SCRIPTS)/buildopamstuff.sh" | \
		docker run --privileged --rm --interactive \
							 --volume "`pwd`":/workspace:rw  --entrypoint "bash" ubuntu:20.04

# Build Z3
z3: $(BINARIES)/z3_$(ARCH)

$(BINARIES)/z3_$(ARCH):
	echo "sh /workspace/$(SCRIPTS)/buildz3.sh" | \
		docker run --rm --interactive \
							 --volume "`pwd`":/workspace:rw  --entrypoint "bash" ubuntu:20.04

# Build eprover
eprover: $(BINARIES)/eprover_$(ARCH)

$(BINARIES)/eprover_$(ARCH):
	echo "sh /workspace/$(SCRIPTS)/buildeprover.sh" | \
		docker run --rm --interactive \
							 --volume "`pwd`":/workspace:rw  --entrypoint "bash" ubuntu:20.04

# Build soufflé
souffle: $(BINARIES)/souffle_$(ARCH).tgz

$(BINARIES)/souffle_$(ARCH).tgz:
	echo "sh /workspace/$(SCRIPTS)/buildsouffle.sh" | \
		docker run --rm --interactive \
							 --volume "`pwd`":/workspace:rw  --entrypoint "bash" ubuntu:20.04

# Test arch
archi:
	echo "sh /workspace/$(SCRIPTS)/archi.sh" | \
		docker run --rm --interactive \
							 --volume "`pwd`":/workspace:rw  --entrypoint "bash" ubuntu:20.04

# Safe way to build multiarchitecture images:
# - build each image on the matching hardware, with the -$(ARCH) tag
# - push the architecture specific images to Dockerhub
# - build a manifest list referencing those images
# - push the manifest list so that the multiarchitecture image exist
manifest:
	docker manifest create $(REPO)$(NAME):$(TAG) $(IMAGES)
	@for arch in $(ARCHS); \
	 do \
	   echo docker manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(TAG) $(REPO)$(NAME):$(TAG)-$$arch; \
	   docker manifest annotate --os linux --arch $$arch $(REPO)$(NAME):$(TAG) $(REPO)$(NAME):$(TAG)-$$arch; \
	 done
	docker manifest push $(REPO)$(NAME):$(TAG)

rmmanifest:
	docker manifest rm $(REPO)$(NAME):$(TAG)

# Create new builder supporting multi architecture images
newbuilder:
	docker buildx create --name newbuilder
	docker buildx use newbuilder

# Hasardous way to build multiarchitecture images:
# - use buildx to try to build the different images using qemu for foreign architectures
# This fails with some images because of the emulation of foreign architectures
# --load with multiarch image fails (2021-02-15), use --push instead
# buildfat:
# 	docker buildx build --push \
# 	  --platform $(PLATFORMS) \
# 	  --build-arg arch=$(ARCH) \
# 	  --tag $(REPO)$(NAME):$(TAG) .
# 	@danglingimages=$$(docker images --filter "dangling=true" -q); \
# 	if [[ $$danglingimages != "" ]]; then \
# 	  docker rmi $$(docker images --filter "dangling=true" -q); \
# 	fi

push:
	docker push $(REPO)$(NAME):$(TAG)-$(ARCH)

save:
	docker save $(REPO)$(NAME):$(TAG)-$(ARCH) | gzip > $(NAME)-$(TAG)-$(ARCH).tar.gz

# Clear caches
clean:
	docker builder prune

clobber:
	docker rmi $(REPO)$(NAME):$(TAG) $(REPO)$(NAME):$(TAG)-$(ARCH)
	docker builder prune --all

run:
	docker run --rm --detach \
    --env USERNAME=`id -n -u` --env USERID=`id -u` \
		--volume "${PWD}":/workspace:rw \
		--publish 6080:80 \
		--name $(NAME) \
		--env RESOLUTION="$(RESOL)" \
		$(REPO)$(NAME):$(TAG)-$(ARCH)
	sleep 5
	open http://localhost:6080 || xdg-open http://localhost:6080 || echo "http://localhost:6080"

runasroot:
	docker run --rm --detach --privileged \
    --env USERNAME=root --env USERID=0 \
		--volume "${PWD}":/workspace:rw \
		--publish 6080:80 \
		--name $(NAME) \
		--env RESOLUTION="$(RESOL)" \
		$(REPO)$(NAME):$(TAG)-$(ARCH)
	sleep 5
	open http://localhost:6080 || xdg-open http://localhost:6080 || echo "http://localhost:6080"

debug:
	docker run --rm --tty --interactive \
		--volume ${PWD}:/workspace:rw \
		--publish 6080:80 \
		--name $(NAME) \
		--env="RESOLUTION=$(RESOL)" \
		--entrypoint=bash \
		$(REPO)$(NAME):$(TAG)-$(ARCH)
