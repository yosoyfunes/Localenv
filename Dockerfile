FROM ubuntu:20.04

ARG KUBECTX_VERSION=v0.9.3
ARG KUBECTL_VERSION=v1.21.0
ARG KUBIE_VERSION=v0.13.1
ARG TERRAFORM_VERSION=0.13.2
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Argentina/Buenos_Aires

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update

RUN \
    apt-get install -y \
    wget \
    curl \
    zip \
    git \
    jq \
    vim \
    nano \
    fzf \
    zsh \
    python3 \
    python3-pip \
    groff \
    amazon-ecr-credential-helper \
    mongodb-clients \
    openjdk-11-jre-headless \
    maven \
    bash-completion \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean;

# Install AWS Cli
RUN python3 -m pip install aws-shell \
    && mkdir -p /root/.aws/ && mkdir -p /root/.m2/

# Install TruffleHog
RUN python3 -m pip install truffleHog3

# Install Terraform 0.13.2
RUN cd /tmp \
    && wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/ \
    && rm ./terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install kubectl
# last version
# $(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && mv kubectl /usr/local/bin/ \
    && chmod +x /usr/local/bin/kubectl

# kubectl bash-completion
RUN echo 'source <(kubectl completion bash)' >>~/.bashrc \
    && echo 'alias k=kubectl' >>~/.bashrc \
    && echo 'complete -F __start_kubectl k' >>~/.bashrc \
    && echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc

# Install kubeselect
RUN wget https://raw.githubusercontent.com/fatliverfreddy/kubeselect/master/kubeselect \
    && chmod +x kubeselect \
    && mv kubeselect /usr/local/bin

# Install kubie
RUN wget https://github.com/sbstp/kubie/releases/download/${KUBIE_VERSION}/kubie-linux-amd64 \
    && chmod +x kubie-linux-amd64 \
    && mv kubie-linux-amd64 /usr/local/bin/kubie

# Install kubectx v0.9.3
RUN wget https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubectx \
    && chmod +x kubectx \
    && mv kubectx /usr/local/bin

# Install kubens v0.9.3
RUN wget https://github.com/ahmetb/kubectx/releases/download/${KUBECTX_VERSION}/kubens \
    && chmod +x kubens \
    && mv kubens /usr/local/bin

# Install Node, NVM, NPM and Grunt, Gulp
RUN cd /tmp \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs build-essential \
    && curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh \
    && npm i -g grunt-cli yarn \
    && npm install gulp-cli -g \
    && npm install -g serverless

# Install eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv /tmp/eksctl /usr/local/bin

# Install Helm3
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
    && chmod 700 get_helm.sh \
    && ./get_helm.sh \
    && rm ./get_helm.sh

# Install Stern
RUN wget https://github.com/wercker/stern/releases/download/1.11.0/stern_linux_amd64 \
    && chmod +x stern_linux_amd64 \
    && mv stern_linux_amd64 stern \
    && mv stern /usr/local/bin/

# Install istio
RUN cd /tmp \
    && curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.9.1 TARGET_ARCH=x86_64 sh - \
    && mv istio-1.9.1 /opt/ \
    && echo 'export PATH=/opt/istio-1.9.1/bin:$PATH' >>~/.bashrc

# Install kubecolor
RUN cd /tmp \
    && wget https://github.com/dty1er/kubecolor/releases/download/v0.0.12/kubecolor_0.0.12_Linux_x86_64.tar.gz \
    && tar -C /usr/local/bin -xzf kubecolor_0.0.12_Linux_x86_64.tar.gz \
    && chmod +x /usr/local/bin/kubecolor \
    && echo 'alias k=kubecolor' >>~/.bashrc \
    && echo 'alias k=kubecolor' >>~/.zshrc

# Install tools for bash prompt
RUN cd /tmp \
    && wget https://raw.githubusercontent.com/jonmosco/kube-ps1/master/kube-ps1.sh \
    && wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/terraform/terraform.plugin.zsh \
    && mv kube-ps1.sh /root/kube-ps1.sh \
    && mv terraform.plugin.zsh /root/terraform.plugin.sh \
    && echo "export KUBE_PS1_SYMBOL_ENABLE=false" >>~/.bashrc \
    && echo "source /root/kube-ps1.sh" >>~/.bashrc \
    && echo "source /root/terraform.plugin.sh" >>~/.bashrc

# Install ohmyzsh
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/deluan/zsh-in-docker/master/zsh-in-docker.sh)" -- \
    -t example \
    -p kube-ps1 \
    -p terraform \
    -p aws

# kubectl bash-completion zsh
RUN echo 'source <(kubectl completion bash)' >>~/.zshrc \
    && echo 'alias k=kubectl' >>~/.zshrc \
    && echo 'complete -F __start_kubectl k' >>~/.zshrc \
    && echo 'source /usr/share/bash-completion/bash_completion' >>~/.zshrc

# Install k9s (monitoring)
RUN cd /tmp \
    && wget https://github.com/derailed/k9s/releases/download/v0.24.9/k9s_Linux_x86_64.tar.gz \
    && tar -xzvf k9s_Linux_x86_64.tar.gz \
    && chmod +x k9s \
    && mv k9s /usr/local/bin/

# Install Hey https://github.com/rakyll/hey
RUN cd /tmp \
    && wget https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 \
    && chmod +x hey_linux_amd64 \
    && mv hey_linux_amd64 hey \
    && mv hey /usr/local/bin/

COPY .bash_aliases /root/.bash_aliases

# Define working directory.
WORKDIR /data

ENTRYPOINT ["bash"]