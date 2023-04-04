# syntax=docker/dockerfile:1

## Build
FROM golang:1.20-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./

RUN make build-linux-noarch

## Deploy
FROM gcr.io/distroless/base-debian11

WORKDIR /

COPY --from=build /app/bin/netlify-cms-oauth-provider /app/netlify-cms-oauth-provider

EXPOSE 3001

USER nonroot:nonroot

ENTRYPOINT ["/app/netlify-cms-oauth-provider"]
