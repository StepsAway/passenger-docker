FROM stepsaway/baseimage-##IMAGE##
MAINTAINER StepsAway <devgru@stepsaway.com>

COPY . /pd_build
RUN /pd_build/install.sh
CMD ["/sbin/my_init"]
EXPOSE 80 443
