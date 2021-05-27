# https://github.com/WASdev/ci.docker.websphere-traditional
FROM ibmcom/websphere-traditional:[was-version]
ENV ENABLE_BASIC_LOGGING=true
#COPY --chown=was:root was-config.props /work/config/
#COPY --chown=was:root myApp.war /work/app/
COPY --chown=was:root virtual-host.py security-off.py /work/config/
RUN /work/configure.sh
