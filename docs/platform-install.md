# Running docs.konghq.com locally

We currently only have installation instructions for MacOS. If you're using Windows or Linux, ensure that you have Ruby (see .ruby-version in the repo root for the current version)+ Node.js installed before running the commands in the [README](https://github.com/Kong/docs.konghq.com#run-locally)

## MacOS Dependency Installation

Install Homebrew + any dependencies that are required:

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install rbenv ruby-build node
```

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
git clone git@github.com:Kong/docs.konghq.com
cd docs.konghq.com
rbenv install $(cat .ruby-version)
rbenv global $(cat .ruby-version)
gem install bundler
```

At this point you can go [back to the README](https://github.com/Kong/docs.konghq.com#run-locally) and continue reading the `Run Locally` instructions.
