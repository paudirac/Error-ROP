FROM perl:5.24
RUN cpanm Carton
COPY cpanfile /src/cpanfile
COPY cpanfile.snapshot /src/cpanfile.snapshot
COPY Makefile /src/Makefile
WORKDIR /src
RUN make devel-deps
COPY . /src
