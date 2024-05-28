FROM arti.hpc.amslabs.hpecorp.net/third-party-docker-stable-local/ghcr.io/dita-ot/dita-ot:4.2.3
COPY *zip /opt/app/
RUN dita --install com.hpe.ditacommon.zip
RUN dita --install com.hpe.html5.common.zip