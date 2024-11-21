FROM vmware/govc as govc
FROM hashicorp/terraform:1.9 as terraform

FROM debian:trixie
RUN apt-get update && \
apt-get install -y vim iputils-ping ca-certificates

COPY talosctl /bin/talosctl
COPY kubectl /bin/kubectl

COPY --from=govc /govc /bin/govc
COPY --from=terraform /bin/terraform /bin/terraform

CMD ["/usr/bin/sleep", "infinity"]
