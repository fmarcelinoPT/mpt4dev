# mpt4dev

My Precious Tools 4 Dev is all the tools that I need in every machine I use.

Everytime I change machine, for instance to test a new Linux distribution, I have to install several tools all over again.

So this project will use Ansible scripts (with Roles) to do so.

## TODO

- [ ] Terraform
- [ ] Docker
- [ ] Microsoft Edge
- [ ] Spotify
- [ ] Synology Drive Client

## List of apps/tools to be installed

- [x] Ansible
- Custom Roles
  - [x] Oh My Zsh (and plugins)
  - [x] [Meld](https://meldmerge.org/)
  - [x] nerd-fonts | <https://github.com/fmarcelinoPT/ansible-role-nerd-fonts>
- `apt` Package Manager
  - [x] net-tools
  - [x] nano
  - [x] parted
  - [x] [Cockpit](https://cockpit-project.org/) | <https://localhost:9090>
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

in: <https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu>

Ubuntu builds are available [in a PPA here](https://launchpad.net/~ansible/+archive/ubuntu/ansible).

To configure the PPA on your system and install Ansible run these commands:

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

## Usage

```bash
ansible-galaxy install -r requirements.yml --force && \
ansible-playbook -i inventory/workstation.yml default-tools.yml -kK
```
