FROM alpine

RUN apk --update add go git \
  && ORG_PATH="github.com/Financial-Times/" \
  && REPO_PATH="${ORG_PATH}ft-vulcan" \
  && export GOPATH=/gopath \
  && export PATH=$PATH:$GOPATH/bin \
  && mkdir -p $GOPATH/src/${ORG_PATH} \
  && ln -s ${PWD} $GOPATH/src/${REPO_PATH} \
  && go get github.com/mailgun/vulcand \
  # checkout older version of vulcan \
  && cd $GOPATH/src/github.com/mailgun/vulcand \
  && git checkout 791285c97cbf28f8eac1ef7222e103990c2d0b08 \
  && go get github.com/Financial-Times/vulcan-session-auth/sauth \
  # checkout the branch with multiple auth keys \
  && cd $GOPATH/src/github.com/Financial-Times/vulcan-session-auth/sauth \
  && git checkout multiple-auth-keys \
  && go get github.com/mailgun/vulcand/vbundle \
  && go get github.com/mailgun/log \
  && cd $GOPATH/src/${REPO_PATH} \
  && vbundle init --middleware=github.com/Financial-Times/vulcan-session-auth/sauth \
  && go build -o vulcand \
  && apk del go git \
  && rm -rf /var/cache/apk/*

CMD /vulcand
