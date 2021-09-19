FROM golang:alpine as build
RUN apk update && apk add --no-cache git
WORKDIR /app
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o todo

# stage - release
FROM gcr.io/distroless/base-debian10 as release
COPY --from=build /app/todo /bin/todo
EXPOSE 8080
CMD ["todo"]
USER 1001



