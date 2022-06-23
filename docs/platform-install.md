# Running docs.konghq.com locally

We currently only have installation instructions for MacOS. If you're using Windows or Linux, ensure that you have Ruby (see .ruby-version in the repo root for the current version)+ Node.js installed before running the commands in the [README](https://github.com/Kong/docs.konghq.com#run-locally)

## Prerequisites
Before you can run the docs locally, you need to generate and add an SSH key to your GitHub account. For more information, see [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and [Adding a new SSH key to your GitHub account](https://docs.github.com/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) in _GitHub Docs_. 

## MacOS Dependency Installation

Install Homebrew + any dependencies that are required:

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install rbenv ruby-build node
```
If you are prompted, follow the Next steps instructions to add Homebrew to your PATH.

Configure `git` and ensure that you're using `zsh`:

```bash
git config --global user.name "Your Name"
git config --global user.email "user@example.com"
chsh -s /bin/zsh
```

Configure `rbenv`:

```bash
rbenv init
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Clone the repository and install dependencies:

```bash
git clone https://github.com/Kong/docs.konghq.com.git
cd docs.konghq.com
rbenv install $(cat .ruby-version)
rbenv global $(cat .ruby-version)
gem install bundler
```

At this point you can go [back to the README](https://github.com/Kong/docs.konghq.com#run-locally) and continue reading the `Run Locally` instructions.
