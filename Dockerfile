# STEP 1 build executable binary
FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git

WORKDIR $GOPATH/src/outyet
COPY . .

RUN GOOS=linux CGO_ENABLED=0 GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/outyet

# STEP 2 build a smallest possible image
FROM scratch

# Set the working directory to the root directory path
WORKDIR /

# Copy over the binary built from the previous stage
COPY --from=builder /go/bin/outyet .

EXPOSE 8080

# Run the outyet binary.
CMD ["./outyet"]
