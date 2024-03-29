docker-framac-novnc
====
A docker image with [Why3](http://why3.lri.fr/) and [Frama-C](https://frama-c.com/) with MetAcsl, installed in a [ubuntu-novnc image](https://hub.docker.com/r/fredblgr/ubuntu-novnc).

This allows you to run Why3 and Frama-C on any computer with Docker and a web browser.  
Supported architectures are `amd64` (`x86_64`) and `arm64` (`aarch64`).

[Soufflé](https://souffle-lang.github.io/) and [SWI-Prolog](https://www.swi-prolog.org/) are also available on this image.

Available on dockerhub at [https://hub.docker.com/r/fredblgr/framac-novnc](https://hub.docker.com/r/fredblgr/framac-novnc)

Source files available on GitHub: [https://github.com/Frederic-Boulanger-UPS/docker-framac-novnc](https://github.com/Frederic-Boulanger-UPS/docker-framac-novnc)

Usage
----
Just run the image in a container as follows:

```
  if [ -z "$SUDO_UID" ]
  then
    # not in sudo
    USER_ID=`id -u`
    USER_NAME=`id -n -u`
  else
    # in a sudo script
    USER_ID=${SUDO_UID}
    USER_NAME=${SUDO_USER}
  fi
  docker run --rm --detach \
    --publish 6080:80 \
    --volume "${PWD}":/workspace:rw \
    --env USERNAME=${USER_NAME} --env USERID=${USER_ID} \
    --env RESOLUTION=1400x900 \
    --name framac-novnc \
    fredblgr/framac-novnc:2022
```

and then point your browser to ```http://localhost:6080```

The current directory is mounted on ```/workspace```.

You may instead use the `startFramacNoVNC.sh` Unix shell script or the `startFramacNoVNC.ps1` power shell script on Windows.
These scripts are available in the GitHub repository.

Testing
-------
You may test why3 and Frama-C: in the container, open a terminal, cd to `/workspace/test-why3` or `/workspace/test-framac` and run the `test-cli.sh` script to test in command line mode, or the `test-gui.sh` to test using the graphical interface.


License
==================

Apache License Version 2.0, January 2004 http://www.apache.org/licenses/LICENSE-2.0

Original work for ubuntu-novnc by [Doro Wu](https://github.com/fcwu)

Adapted by [Frédéric Boulanger](https://github.com/Frederic-Boulanger-UPS)
