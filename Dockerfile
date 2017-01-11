FROM debian:stable

ENV RAINBOWCRACK_VERSION=1.6.1
ENV RAINBOWCRACK_URL=http://project-rainbowcrack.com/rainbowcrack-${RAINBOWCRACK_VERSION}-linux64.zip
ENV RAINBOWCRACK_PATH=/opt/rainbowcrack/rainbowcrack-${RAINBOWCRACK_VERSION}-linux64
ENV PATH=/usr/local/bin:${PATH}

# Installation dependencies
RUN apt-get -q update && apt-get -q -y install wget unzip

# Download and install Rainbowcrack
RUN wget -O /tmp/rainbowcrack.zip ${RAINBOWCRACK_URL} && \
    mkdir -p /opt/rainbowcrack/tables && \
    unzip /tmp/rainbowcrack.zip -d /opt/rainbowcrack && \
    for m in rcrack rt2rtc rtc2rt rtgen rtsort; do \
        chmod +x ${RAINBOWCRACK_PATH}/$m; \
        ln -s ${RAINBOWCRACK_PATH}/$m /usr/local/bin/; \
    done

ENV RAINBOWCRACK_BIN=${RAINBOWCRACK_PATH}/rcrack
COPY util/entrypoint.sh /opt/rainbowcrack/


# NOTE: rainbow tables are very large. They should be stored in a separate
# volume and mounted at run-time.
# For additional rainbow tables, see: http://project-rainbowcrack.com/table.htm

VOLUME ["/opt/rainbowcrack/tables", "/tmp/hash"]
ENTRYPOINT ["sh", "/opt/rainbowcrack/entrypoint.sh"]
