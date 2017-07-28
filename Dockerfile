FROM perl:5.24
RUN cpanm Carton
COPY cpanfile /src/cpanfile
COPY Makefile /src/Makefile
WORKDIR /src
RUN make devel-deps
COPY . /src
