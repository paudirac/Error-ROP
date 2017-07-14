FROM perl:5.24
RUN cpanm Carton
RUN make devel-deps
COPY . /src
WORKDIR /src
