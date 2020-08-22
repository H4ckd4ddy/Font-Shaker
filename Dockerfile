FROM perl

RUN cpan Font::TTF
ADD Font-TTF-Scripts-1.06.tar.gz /
WORKDIR /Font-TTF-Scripts-1.06
RUN perl Makefile.PL;make test;make install
WORKDIR /

RUN apt update;apt install -y fonttools

ADD *.sh /
RUN chmod +x /*.sh

ENTRYPOINT ["/font_shaker.sh"]