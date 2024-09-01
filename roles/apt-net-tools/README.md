# Ansible Role: apt-net-tools

## Description

This Ansible role installs the latest version of `net-tools` using the `apt` module. It is designed to be used in other roles or playbooks.

## Requirements

- Ansible 2.10 or higher

## Role Variables

This role does not have any configurable variables.

## Dependencies

- This role requires the `apt` module

## Example Playbook

```yaml
---
- name: Install net-tools Package
  hosts: all
  roles:
    - apt-net-tools
```

## License

This role is licensed under the MIT License.

## Author Information

n/a

## Additional Notes

- This role requires root privileges to install `net-tools`.
- The `apt_cache_update` variable can be set to `false` if the apt cache is already updated.
- This role is tested on Ubuntu 24.04
