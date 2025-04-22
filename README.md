# mpt4dev

My Precious Tools 4 Dev is all the tools that I need in every machine I use.

Every time I change machine, for instance to test a new Linux distribution, I have to install several tools all over again.

So this project will use Ansible scripts (with Roles) to do so.

## TODO

- [ ] Microsoft Edge
- [ ] Spotify
- [ ] Spotube
- [ ] Synology Drive Client
- [ ] https://extensions.gnome.org/extension/4481/forge/

## List of apps/tools to be installed

- [x] Ansible
- Custom Roles
  - [x] Oh My Zsh
    - Plugins
      - [x] ohmyzsh-full-autoupdate
      - [x] zsh-autosuggestions
      - [x] zsh-syntax-highlighting
      - [x] zsh-bat
      - [x] you-should-use
      - [x] docker
      - [x] kubectl
      - [x] microk8s
      - [x] minikube
      - [x] git
      - [x] sudo
      - [x] ansible
      - [x] terraform
      - [x] npm
      - [x] pip
      - [x] z
  - [x] [Meld](https://meldmerge.org/)
  - [x] [nerd-fonts](https://github.com/fmarcelinoPT/ansible-role-nerd-fonts)
  - [x] [Terraform](https://github.com/fmarcelinoPT/ansible-role-terraform)
  - [x] [JetBrains Rider](https://github.com/fmarcelinoPT/ansible-role-jetbrains-rider)
  - [x] [JetBrains Toolbox](https://github.com/fmarcelinoPT/ansible-role-jetbrains-toolbox)
  - [x] [Docker](https://github.com/fmarcelinoPT/ansible-role-docker)
- `apt` Package Manager
  - [x] net-tools
  - [x] nano
  - [x] parted
  - [x] [Cockpit](https://cockpit-project.org/) | <https://localhost:9090>
  - [x] unzip
- `apt` Package Manager - Desktop
  - [x] snapd
  - [x] yakuake
  - [x] KeePasXC (keepassxc)
  - [x] FileZilla (filezilla)
  - [x] Krita (krita)
  - [x] Remmina (remmina)
  - [x] NetworkManager - Fortinet SSLVPN Client (network-manager-fortisslvpn)
  - [x] NetworkManager - OpenVPN Client (network-manager-openvpn)
- `snapd` Package Manager
  - [ ]
- `snapd` Package Manager - Desktop
  - [x] obsidian
  - [x] code
  - [x] drawio

## List of apps/tools TO BE REMOVED

- Package Manager
  - [ ] vim

## Installing Ansible

### Ubuntu

in: <https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu>

Ubuntu builds are available [in a PPA here](https://launchpad.net/~ansible/+archive/ubuntu/ansible).

To configure the PPA on your system and install Ansible run these commands:

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
sudo apt install python-argcomplete
ansible-galaxy collection install community.general
```

### RedHat

in: <https://docs.ansible.com/ansible/2.9/installation_guide/intro_installation.html#installing-ansible-on-rhel-centos-or-fedora>

```bash
sudo dnf install ansible
sudo dnf install python-argcomplete
ansible-galaxy collection install community.general
```

## Update fingerprints

```bash
ssh -i ~/.ssh/onemarc_rsa donutuse@poseidon.onemarc.io
ssh -i ~/.ssh/onemarc_rsa donutuse@zeus.onemarc.io
ssh -i ~/.ssh/onemarc_rsa donutuse@hera.onemarc.io
ssh -i ~/.ssh/onemarc_rsa donutuse@kronos.onemarc.io

## Usage

```bash
ansible-galaxy install -r inventory/hypervisors_requirements.yml --force && \
ansible-playbook -i inventory/hypervisors.yml default-tools.yml
```

```bash
ansible-galaxy install -r inventory/servers_requirements.yml --force && \
ansible-playbook -i inventory/servers.yml default-tools.yml
```

```bash
ansible-galaxy install -r inventory/workstation_requirements.yml --force && \
ansible-playbook -i inventory/workstation.yml default-tools.yml
```

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Author Information

This scripts was created at 2024 by [fmarcelinoPT](https://github.com/fmarcelinoPT). Feel free to customize or extend it to fit your needs.
