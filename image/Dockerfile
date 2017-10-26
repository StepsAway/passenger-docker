FROM stepsaway/baseimage-##IMAGE##
LABEL maintainer="StepsAway <infra-ops@stepsaway.com>"

COPY . /pd_build
RUN /pd_build/install.sh
CMD ["/sbin/my_init"]
EXPOSE 80 443
