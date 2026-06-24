FROM ubuntu:22.04

# Avoid tzdata interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    tmux \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a test user with a clean home directory
RUN useradd -m -s /bin/bash tester && \
    echo "tester ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER tester
WORKDIR /home/tester

# Copy the local repo as a local remote to test offline/unpushed changes
COPY --chown=tester:tester . /home/tester/tmux-config-repo

# Test the installation using the local path instead of pulling from GitHub
# We then run 'tmux-mgr status' to verify symlinks were created correctly
CMD ["/bin/bash", "-c", "export REPO_URL=/home/tester/tmux-config-repo && bash /home/tester/tmux-config-repo/install.sh && export PATH=$HOME/.local/bin:$PATH && tmux-mgr status && bash /home/tester/tmux-config-repo/tests/test-keystrokes.sh"]
