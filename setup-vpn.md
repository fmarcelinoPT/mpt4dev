1. sudo dnf install wireguard-tools -y
1. sudo systemctl enable --now systemd-resolved
1. sudo nano /etc/wireguard/wg0.conf:

    ```properties
    [Interface]
    PrivateKey = aPK99ACgOnzOutOXcuEqFqiDCheuxR9/gqy5qVIhYmM=
    Address = 10.128.86.2/24
    DNS = 192.168.8.10

    [Peer]
    PublicKey = nb0Ma9vTQuSzvBH2rdzjmjqUOgdoq5rQVhL9GD1akQE=
    PresharedKey = EpmThQirMbt9/fB0bT3UG3qulAAkixbfxyuavjJ4yUY=
    Endpoint = 176.79.92.179:51666
    AllowedIPs = 0.0.0.0/0, ::0/0
    ```

1. `sudo wg-quick up wg0`
1. `sudo wg-quick down wg0`
1. `sudo wg show`

    ```properties
    wget ftp://hdesk:'!f19840306#'@rivendell.onemarc.io/storage/_recover/downloads/en-us_windows_11_business_editions_version_24h2_updated_dec_2024_x64_dvd_063626e9.iso

    wget ftp://filipe.marcelino:8YFiQvDjiI6Jx6WI7tq6@rivendell.onemarc.io/storage/_recover/downloads/en-us_windows_11_business_editions_version_24h2_updated_dec_2024_x64_dvd_063626e9.iso
    ```
