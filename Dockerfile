FROM golang:1.10-stretch

ARG git_tag
ARG git_commit

RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

WORKDIR /go/src/github.com/ory/hydra

ADD ./Gopkg.lock ./Gopkg.lock
ADD ./Gopkg.toml ./Gopkg.toml
RUN dep ensure -vendor-only

ADD . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -X github.com/ory/hydra/cmd.Version=$git_tag -X github.com/ory/hydra/cmd.BuildTime=`TZ=UTC date -u '+%Y-%m-%dT%H:%M:%SZ'` -X github.com/ory/hydra/cmd.GitHash=$git_commit" -a -installsuffix cgo -o hydra

RUN cp /go/src/github.com/ory/hydra/hydra /usr/bin/hydra

CMD ["cat"]