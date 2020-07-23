FROM veupathdb/galaxy-python-tools:latest

# # # # # # # # # # # # # # # #
#                             #
#  General Container Config   #
#                             #
# # # # # # # # # # # # # # # #

WORKDIR /app

ADD https://github.com/Foxcapades/gh-latest/releases/download/v1.0.4/gh-latest-linux.v1.0.4.tar.gz tmp.tgz

RUN tar -xzf tmp.tgz \
    && mv gh-latest /usr/bin \
    && rm tmp.tgz \
    && export server_url=$(gh-latest -u VEuPathDB/util-user-dataset-handler-server | grep server-) \
    && echo using server version ${server_url} \
    && wget ${server_url} -O tmp.tgz \
    && tar -xzf tmp.tgz \
    && rm tmp.tgz

# # # # # # # # # # # # # # # #
#                             #
#  Handler Specific Config    #
#                             #
# # # # # # # # # # # # # # # #

COPY lib /opt/handler/lib
COPY bin /opt/handler/bin
COPY config.yml config.yml
RUN pip install git+https://github.com/VEuPathDB/dataset-handler-python-base \
    && chmod +x /opt/handler/bin/exportBiomToEuPathDB

EXPOSE 80
CMD ./server
