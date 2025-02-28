# Build stage
FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY main.go .
RUN go mod init datetime-api
RUN go build -o datetime-api

# Final stage
FROM alpine:latest

WORKDIR /root/

COPY --from=builder /app/datetime-api .

EXPOSE 8080

CMD ["./datetime-api"]
