FROM golang:1.19 AS build

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

EXPOSE 8080

##
FROM build AS dev

RUN go install github.com/cosmtrek/air@latest

CMD ["air", "-c", ".air.toml"]

##
FROM build AS prod-build

RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /bin/go-api

##
FROM scratch AS prod

COPY --from=prod-build /bin/go-api /bin/go-api

CMD ["/bin/go-api"]

