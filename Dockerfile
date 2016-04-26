FROM alpine

RUN apk --update add go git \
  && export GOPATH=/gopath \
  && go get github.com/Financial-Times/vulcand \
  && cd $GOPATH/src/github.com/Financial-Times/vulcand \
  && git checkout daaa02dfc0d1d5e6f34440825008a743cc5b442f \
  && go build -o /vulcand \
  && apk del go git \
  && rm -rf /var/cache/apk/*

CMD /vulcand
