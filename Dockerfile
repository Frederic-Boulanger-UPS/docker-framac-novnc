FROM fredblgr/ubuntu-novnc:20.04

ARG arch

# Avoid prompts for time zone
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

# Fix issue with libGL on Windows
ENV LIBGL_ALWAYS_INDIRECT=1

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y x11-apps xdg-utils wget gcc make cmake nano python3-pip

RUN apt-get install -y ocaml menhir \
	libnum-ocaml-dev libzarith-ocaml-dev libzip-ocaml-dev \
	libmenhir-ocaml-dev liblablgtk3-ocaml-dev liblablgtksourceview3-ocaml-dev \
	libocamlgraph-ocaml-dev libre-ocaml-dev libjs-of-ocaml-dev

RUN apt-get install at-spi2-core

#RUN apt-get install -y alt-ergo
COPY altergo/alt-ergo_240_$arch /usr/local/bin/alt-ergo
RUN chmod a+x /usr/local/bin/alt-ergo

# Install Z3 4.8.6
# RUN wget https://github.com/Z3Prover/z3/archive/z3-4.8.6.tar.gz \
# 	&& tar zxf z3-4.8.6.tar.gz \
# 	&& cd z3-z3-4.8.6; env PYTHON=python3 ./configure; cd build; make; make install; \
# 	cd ../..; rm -r z3-*
COPY z3/z3_486_$arch /usr/local/bin/z3
RUN chmod a+x /usr/local/bin/z3

# Install E prover
# RUN wget http://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_2.0/E.tgz \
# 	 && tar zxf E.tgz \
# 	 && cd E; ./configure --prefix=/usr/local; make; make install; \
# 	 cd ..; rm -r E E.tgz
COPY eprover/eprover_20_$arch /usr/local/bin/eprover
RUN chmod a+x /usr/local/bin/eprover

# Install CVC4
RUN if [ "$arch" = "amd64" ]; then pip3 install toml; fi
RUN if [ "$arch" = "amd64" ]; then apt-get install -y openjdk-14-jdk; fi

# RUN if [ "$arch" = "amd64" ]; then wget https://github.com/CVC4/CVC4/archive/1.7.tar.gz \
# 	&& tar zxf 1.7.tar.gz \
# 	&& cd CVC4-1.7; ./contrib/get-antlr-3.4 && ./configure.sh \
# 	&& cd build && make && make install \
# 	&& cd ../.. && rm -r CVC4* && rm 1.7.tar.gz; fi
COPY cvc4/cvc4_17_x86_64 /usr/local/bin/cvc4
COPY cvc4/libcvc4parser.so.6 /usr/local/lib/
COPY cvc4/libcvc4.so.6 /usr/local/lib/
RUN if [ "$arch" = "amd64" ]; \
    then chmod a+x /usr/local/bin/cvc4 ; \
	  else rm /usr/local/bin/cvc4 /usr/local/lib/libcvc4* ; \
	  fi

# Install why3
RUN wget https://gforge.inria.fr/frs/download.php/file/38425/why3-1.4.0.tar.gz
RUN wget https://gforge.inria.fr/frs/download.php/file/38367/why3-1.3.3.tar.gz
RUN tar zxf why3-1.3.3.tar.gz
RUN tar zxf why3-1.4.0.tar.gz
RUN cp why3-1.4.0/drivers/alt_ergo* why3-1.3.3/drivers/
RUN cp why3-1.4.0/share/provers-detection-data.conf why3-1.3.3/share/
RUN cd why3-1.3.3; ./configure; make ; make install ;\
	make byte; make install-lib ;
RUN yes | rm -rf why3-*

# COPY why3-1.4.0.tar.gz /root/
# RUN cd /root ; tar zxf why3-1.4.0.tar.gz \
# 	&& cd why3-1.4.0; ./configure; make ; make install ;\
# 	make byte; make install-lib ; \
# 	cd ..; yes | rm -rf why3-1.4.0*

RUN mkdir -p /home/ubuntu \
    && why3 config --detect-provers \
    && mv /home/ubuntu/.why3.conf /root/ ; \
    echo 'cp /root/.why3.conf ${HOME}' >> /root/.novnc_setup
# RUN mkdir -p /home/ubuntu \
#     && why3 config detect \
#     && mv /home/ubuntu/.why3.conf /root/ ; \
#     echo 'cp /root/.why3.conf ${HOME}' >> /root/.novnc_setup

# Install Frama-C
RUN apt-get install -y yaru-theme-icon
RUN wget https://git.frama-c.com/pub/frama-c/-/archive/22.0/frama-c-22.0.tar.gz
RUN tar zxf frama-c-22.0.tar.gz; cd frama-c-22.0; autoconf; ./configure; \
		make; make install ; \
		cd ..; rm -rf frama-c-22.0*

RUN wget https://git.frama-c.com/pub/meta/-/archive/0.1/frama-c-metacsl-0.1.tar.gz \
	&& tar zxf frama-c-metacsl-0.1.tar.gz \
	&& cd `ls -d meta-0.1-*` \
	&& autoconf && ./configure \
	&& make \
	&& make install ; cd ..; rm -rf meta-0.1-* frama-c-metacsl-0.1.tar.gz

RUN apt autoremove && apt autoclean
