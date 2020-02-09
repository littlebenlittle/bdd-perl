FROM perl:5.30
WORKDIR /usr/src/bdd
COPY . .
ENV PERL5LIB=/usr/src/bdd/lib
ENTRYPOINT [ "perl", "main.pl" ]

