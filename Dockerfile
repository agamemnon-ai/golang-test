FROM golang:1.19.1-alpine
ENV ENV1 Hello 
ENV ENV2 golang
RUN apk update && mkdir -p /go/src/app
WORKDIR /go/src/app
ADD ./cmd/app /go/src/app
RUN go mod init sample && go get -u golang.org/x/tools/cmd/goimports
CMD [ "go", "run", "main.go" ]