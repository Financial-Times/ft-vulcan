FROM alpine

RUN apk --update add go git \
  &&  ORG_PATH="github.com/mailgun" \
  && REPO_PATH="${ORG_PATH}/vulcan-bundle" \
  && export GOPATH=/gopath \
  && export PATH=$PATH:$GOPATH/bin \
  && mkdir -p $GOPATH/src/${ORG_PATH} \
  && ln -s ${PWD} $GOPATH/src/${REPO_PATH} \
  && cd $GOPATH/src/${REPO_PATH} \
  && go get github.com/mailgun/vulcand \
  && go get github.com/Zapadlo/vulcan-session-auth/sauth \
  && go get github.com/mailgun/vulcand/vbundle \
  && go get github.com/mailgun/log \
  && vbundle init --middleware=github.com/Zapadlo/vulcan-session-auth/sauth \
  && go build -o vulcand \
  && apk del go git \
  && rm -rf /var/cache/apk/*

CMD /vulcand
