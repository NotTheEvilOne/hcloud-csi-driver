FROM golang:1.15 as builder
WORKDIR /csi
ADD go.mod go.sum /csi/
RUN go mod download
ADD . /csi/
RUN CGO_ENABLED=0 go build -o driver.bin github.com/hetznercloud/csi-driver/cmd/driver

FROM alpine:3.12
RUN apk add --no-cache ca-certificates e2fsprogs xfsprogs blkid xfsprogs-extra e2fsprogs-extra
COPY --from=builder /csi/driver.bin /bin/hcloud-csi-driver
ENTRYPOINT ["/bin/hcloud-csi-driver"]
