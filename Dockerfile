FROM alpine

MAINTAINER David Tesar

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="helm-kubectl" \
      org.label-schema.url="https://hub.docker.com/r/dtzar/helm-kubectl/" \
      org.label-schema.vcs-url="https://github.com/dtzar/helm-kubectl" \
      org.label-schema.build-date=$BUILD_DATE

# Note: Latest version of kubectl may be found at:
# https://aur.archlinux.org/packages/kubectl-bin/
ENV KUBE_LATEST_VERSION="v1.7.4"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.6.0"
ENV FILENAME="helm-${HELM_VERSION}-linux-amd64.tar.gz"

RUN apk add --update --no-cache ca-certificates curl jq bash \
    && curl -L https://github.com/mikefarah/yq/releases/download/1.14.0/yq_linux_amd64 -o /usr/local/bin/yq \
    && chmod a+x /usr/local/bin/yq \
    && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && curl -L http://storage.googleapis.com/kubernetes-helm/${FILENAME} -o /tmp/${FILENAME} \
    && tar -zxvf /tmp/${FILENAME} -C /tmp \
    && mv /tmp/linux-amd64/helm /bin/helm \
    # Cleanup uncessary files
    && rm /var/cache/apk/* \
    && rm -rf /tmp/*

WORKDIR /config

CMD bash
