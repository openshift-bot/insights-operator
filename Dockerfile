FROM quay-proxy.ci.openshift.org/openshift/ci:ocp_builder_rhel-9-golang-1.24-openshift-4.20 AS builder
WORKDIR /go/src/github.com/openshift/insights-operator
COPY . .
ENV GOEXPERIMENT=strictfipsruntime
RUN make build

FROM quay-proxy.ci.openshift.org/openshift/ci:ocp_4.20_base-rhel9
COPY --from=builder /go/src/github.com/openshift/insights-operator/bin/insights-operator /usr/bin/
COPY config/pod.yaml /etc/insights-operator/server.yaml
COPY manifests /manifests
LABEL io.openshift.release.operator=true
ENTRYPOINT ["/usr/bin/insights-operator"]
