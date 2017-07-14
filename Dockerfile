FROM perl:5.24
RUN cpanm Carton
COPY . /src
WORKDIR /src
RUN make devel-deps
