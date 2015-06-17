FROM debian:jessie

ENV HOME=/root DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

RUN true \
 && echo 'tzdata tzdata/Areas select America' > /etc/preseed \
 && echo 'tzdata tzdata/Zones/America select Los_Angeles' >> /etc/preseed \
 && echo 'locales locales/locales_to_be_generated multiselect     en_US.UTF-8 UTF-8' >> /etc/preseed \
 && echo 'locales locales/default_environment_locale      select  en_US.UTF-8' >> /etc/preseed \
 && echo 'path-exclude /usr/share/doc/*' >> /etc/dpkg/dpkg.cfg.d/01_nodoc \
 && echo 'path-exclude /usr/share/info/*' >> /etc/dpkg/dpkg.cfg.d/01_nodoc \
 && echo 'path-exclude=/usr/share/locale/*' >> /etc/dpkg/dpkg.cfg.d/01_nodoc \
 && echo 'path-include=/usr/share/locale/en*' >> /etc/dpkg/dpkg.cfg.d/01_nodoc \
 && echo 'path-include=/usr/share/locale/locale.alias' >> /etc/dpkg/dpkg.cfg.d/01_nodoc \
 && echo 'path-exclude=/usr/share/man/*' >> /etc/dpkg/dpkg.cfg.d/01_nodoc \
 && echo 'path-include=/usr/share/man/en*' >> /etc/dpkg/dpkg.cfg.d/01_nodoc \
 && echo 'path-include=/usr/share/man/man[1-9]/*' >> /etc/dpkg/dpkg.cfg.d/01_nodoc \
 && debconf-set-selections /etc/preseed \
 && apt-get update -yy \
 && apt-get upgrade -yy \
 && apt-get install -yy --no-install-recommends --no-install-suggests \
        locales libgmp10 \
        texlive-latex-base texlive-pictures texlive-fonts-recommended latex-beamer \
        lmodern ttf-bitstream-vera \
 && export LANGUAGE=en_US.UTF-8 \
 && export LANG=en_US.UTF-8 \
 && export LC_ALL=en_US.UTF-8 \
 && locale-gen en_US.UTF-8 \
 && dpkg-reconfigure -f noninteractive locales \
 && apt-get clean -yy \
 && apt-get autoclean -yy \
 && apt-get autoremove -yy \
 && rm -rf /var/cache/debconf/*-old \
 && rm -rf /var/lib/apt/lists/*

ADD ./target/* /usr/bin/

WORKDIR /source

ADD ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
