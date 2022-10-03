FROM ubuntu:latest

ARG ARCH
ENV ARCH ${ARCH:-amd64}

ARG USER_ID
ENV USER_ID ${USER_ID}

ARG GROUP_ID
ENV GROUP_ID ${GROUP_ID}

ARG BINARIES_FOLDER
ENV BINARIES_FOLDER ${BINARIES_FOLDER:-/usr/local/bin}

RUN apt update -y && apt upgrade -y && \
    apt install -y sudo curl bash unzip tar xz-utils git zsh

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY ./.zshrc ~/.zshrc

ARG TERRAFORM_VERSION
ENV TERRAFORM_VERSION ${TERRAFORM_VERSION:-1.2.6}
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip /tmp/terraform.zip
RUN unzip /tmp/terraform.zip -d ${BINARIES_FOLDER}

# (x86_64|aarch64)
ARG AWSCLI_ARCH
ENV AWSCLI_ARCH ${AWSCLI_ARCH:-x86_64}
ARG AWSCLI_VERSION
ENV AWSCLI_VERSION ${AWSCLI_VERSION:-2.7.21}
ADD https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI_ARCH}-${AWSCLI_VERSION}.zip /tmp/awscliv2.zip
RUN unzip /tmp/awscliv2.zip -d /tmp

RUN /tmp/aws/install -i /usr/local/aws-cli -b ${BINARIES_FOLDER}

ARG AWSRUNAS_VERSION
ENV AWSRUNAS_VERSION ${AWSRUNAS_VERSION:-3.4.0}
ADD https://github.com/mmmorris1975/aws-runas/releases/download/${AWSRUNAS_VERSION}/aws-runas-${AWSRUNAS_VERSION}-linux-${ARCH}.zip /tmp/aws-runas.zip
RUN unzip /tmp/aws-runas.zip -d ${BINARIES_FOLDER}

ARG TFLINT_VERSION=0.41.0
ENV TFLINT_VERSION=${TFLINT_VERSION:-0.41.0}
ADD https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_${ARCH}.zip /tmp/tflint.zip
RUN unzip /tmp/tflint.zip -d ${BINARIES_FOLDER}

ARG TERRAFORM_DOCS_VERSION
ENV TERRAFORM_DOCS_VERSION ${TERRAFORM_DOCS_VERSION:-0.16.0}
ADD https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOCS_VERSION}/terraform-docs-v${TERRAFORM_DOCS_VERSION}-linux-${ARCH}.tar.gz /tmp/terraform-docs.tar.gz
RUN tar -xzf /tmp/terraform-docs.tar.gz -C ${BINARIES_FOLDER}

ARG TERRAGRUNT_VERSION
ENV TERRAGRUNT_VERSION ${TERRAGRUNT_VERSION:-0.38.6}
ADD https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${ARCH} ${BINARIES_FOLDER}/terragrunt
RUN chmod +x ${BINARIES_FOLDER}/terragrunt

ARG TFSEC_VERSION
ENV TFSEC_VERSION ${TFSEC_VERSION:-1.27.1}
ADD https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-${ARCH} ${BINARIES_FOLDER}/tfsec
RUN chmod +x ${BINARIES_FOLDER}/tfsec

ARG GLIBC_VERSION
ENV GLIBC_VERSION ${GLIBC_VERSION:-2.27}
ADD http://archive.ubuntu.com/ubuntu/pool/main/g/glibc/glibc_${GLIBC_VERSION}.orig.tar.xz /tmp/glibc.tar.xz
RUN tar -xf /tmp/glibc.tar.xz -C ${BINARIES_FOLDER}

# (x64|arm64)
ARG NODEJS_ARCH
ENV NODEJS_ARCH ${NODEJS_ARCH:-x64}
ARG NODEJS_VERSION
ENV NODEJS_VERSION ${NODEJS_VERSION:-16.17.1}
ADD https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-${NODEJS_ARCH}.tar.xz /tmp/nodejs.tar.xz
RUN tar -xf /tmp/nodejs.tar.xz -C ${BINARIES_FOLDER}

# TODO: Install python3
# ARG PYTHON3_VERSION
# ENV PYTHON3_VERSION ${PYTHON3_VERSION:-3.10.7}
# ADD https://www.python.org/ftp/python/${PYTHON3_VERSION}/Python-${PYTHON3_VERSION}.tgz /tmp/python3.tgz
# RUN tar -xzf /tmp/python3.tgz -C ${BINARIES_FOLDER}
RUN apt install -y python3 python3-pip
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --ignore-installed distlib -r /tmp/requirements.txt

# Install brew
# RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


ENTRYPOINT [ "/bin/zsh" ]