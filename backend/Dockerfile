FROM rust:1.99-alpine AS build

RUN apk --no-cache add musl-dev ca-certificates

WORKDIR /app

# Caching dependencies
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -rf src

# Building
COPY . .
RUN touch src/main.rs
RUN cargo build --release

# Prod
FROM alpine:latest

RUN apk --no-cache add ca-certificates
RUN addgroup -S backend && adduser -S backend -G backend

RUN mkdir /app
WORKDIR /app
COPY --from=build /app/target/release/tr-back server
COPY static ./static

USER backend
EXPOSE 8080
ENTRYPOINT ["/app/server"]
