# build the Go API
FROM golang:latest AS builder

RUN mkdir /app
# ADD . /app
# COPY go-server go-server

WORKDIR /app
COPY go-server go-server
WORKDIR /app/go-server 

# COPY go.mod go.sum ./
# RUN go mod download
# RUN go get -u github.com/pressly/goose/cmd/goose
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-w" -a -o /main .

# build the React App
FROM node:alpine
RUN apk --no-cache add ca-certificates
# COPY /app/client .
RUN mkdir -v app
WORKDIR /app
COPY client client
WORKDIR /app/client
RUN npm start
COPY --from=builder /app/go-server/main main
COPY --from=builder /app/go-server/.env .env
COPY --from=node_builder /app/client/build ./web
RUN chmod +x ./main
EXPOSE 8080
EXPOSE 3000
CMD ./main
# RUN npm run build
# copy the build assets to a minimal
# alpine image
# FROM alpine:latest