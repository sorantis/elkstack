##############################################################################
# Copyright (c) 2015 Ericsson AB and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

FROM ubuntu:14.04
MAINTAINER Dimitri Mazmanov <dimitri.mazmanov@ericsson.com>

COPY . /tmp/elkstack

RUN cd /tmp/elkstack

ADD ./elkstack.sh /tmp/elkstack/elkstack.sh

CMD ["/bin/bash", "/elkstack.sh"]

EXPOSE 80
EXPOSE 22
EXPOSE 9200
EXPOSE 5044
WORKDIR /home/elkstack
