FROM golang:1.16-alpine as builder

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY *.go ./
COPY proto/ proto/
RUN CGO_ENABLED=0 GOOS=linux go build -a -o coredns-grpc-redis

FROM alpine:3.11.3
COPY --from=builder /app/coredns-grpc-redis .

EXPOSE 9005

ENTRYPOINT [ "./coredns-grpc-redis" ]