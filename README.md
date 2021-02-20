# docker-framac-novnc

A docker image with why3 and frama-c installed in an ubuntu-novnc image.

Just run the image in container as follows:

```
	docker run --rm --detach \
		--volume ${PWD}:/workspace:rw \
		--publish 6080:80 \
		--name $(NAME) \
		--env="RESOLUTION=1200x800" \
		$(REPO)$(NAME):$(TAG)-$(ARCH)
```

and then point your browser to ```http://localhost:6080```

The current directory is mounted on ```/workspace```.

License
==================

Apache License Version 2.0, January 2004 http://www.apache.org/licenses/LICENSE-2.0

Original work for ubuntu-novnc by [Doro Wu](https://github.com/fcwu)

Adapted by [Frédéric Boulanger](https://github.com/Frederic-Boulanger-UPS)
