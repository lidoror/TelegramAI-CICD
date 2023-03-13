FROM amazonlinux:2 as installer

# aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN yum update -y \
  && yum install -y unzip \
  && unzip awscliv2.zip \
  && ./aws/install --bin-dir /aws-cli-bin/


FROM jenkins/agent
COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
COPY --from=bitnami/kubectl:1.20.9 /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

USER root
RUN apt-get update

RUN apt-get install -y python3
RUN apt-get install -y python3-pip
USER jenkins
