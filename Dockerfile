FROM jenkins/jenkins:lts

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Add Docker’s official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up Docker repo (Jenkins LTS uses Debian 12 "bookworm")
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian \
    bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI only
RUN apt-get update && apt-get install -y docker-ce-cli

# Install Docker Compose V2
RUN mkdir -p /usr/local/lib/docker/cli-plugins && \
    curl -SL "https://github.com/docker/compose/releases/download/v2.40.1/docker-compose-linux-x86_64" \
    -o /usr/local/lib/docker/cli-plugins/docker-compose && \
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# No need for `usermod -aG docker jenkins` — group doesn't exist and isn't needed

USER jenkins

# Install Jenkins plugins
RUN jenkins-plugin-cli --plugins "docker-workflow git workflow-aggregator blueocean"