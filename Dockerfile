FROM docker:1.7-dind
MAINTAINER Jeremy Derr <jeremy@bypassmobile.com>

RUN apk update; apk add bash
ADD cleanup.sh /cleanup.sh
RUN chmod +x /cleanup.sh

CMD ["/cleanup.sh"]
