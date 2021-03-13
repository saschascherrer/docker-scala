FROM docker.io/library/adoptopenjdk:11

MAINTAINER Sascha Scherrer <dev@saschascherrer.de>

ENV SCALA_HOME "/opt/scala/scala-2.13.5"
ENV PATH "$SCALA_HOME/bin:$PATH"

COPY scala-2.13.5.tgz /opt/scala/
RUN tar -xf /opt/scala/scala-2.13.5.tgz \
 && mv scala-2.13.5 $SCALA_HOME \
 && rm /opt/scala/scala-2.13.5.tgz \
 && mkdir /opt/workdir
WORKDIR /opt/workdir

RUN echo "===== DEBUG INFOS =====" \
 && echo "/opt" && ls -l /opt \
 && echo "/opt/scala" && ls -l /opt/scala \
 && echo "/opt/scala/scala-2.13.5" && ls -l /opt/scala/scala-2.13.5 \
 && echo "SCALA_HOME=$SCALA_HOME" \
 && echo "PATH=$PATH" \
 && echo "Java  VERSION: $(java -version)"

COPY . .
RUN echo "===== HELLO WORLD =====" \
 && echo "Current path : $(pwd)" \
 && scalac Hello.scala \
 && scala Hello \
