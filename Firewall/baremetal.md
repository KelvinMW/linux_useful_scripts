To **allow all external access temporarily** and **revert later**, here are the steps depending on your firewall system. These commands **open all ports** (insecure for production), so make sure to **revert as soon as possible**.

---

## 🚨 Allow All Incoming Connections (Temporarily)

### 🔹 For `firewalld`

```bash
# Set default zone to allow all traffic
sudo firewall-cmd --set-default-zone=trusted

# Or add the interface to the trusted zone
sudo firewall-cmd --zone=trusted --change-interface=eth0  # replace eth0 with your NIC

# Reload to apply
sudo firewall-cmd --reload
```

---

### 🔹 For `iptables`

```bash
# Flush all rules (allow all)
sudo iptables -F

# Set default policies to ACCEPT
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
```

---

### 🔹 For `ufw` (Uncomplicated Firewall)

```bash
# Disable ufw (disables all firewall rules)
sudo ufw disable
```

---

## 🔁 Reverting Back (Re-secure the system)

### 🔹 For `firewalld`

```bash
# Reset default zone back (e.g., public)
sudo firewall-cmd --set-default-zone=public
sudo firewall-cmd --reload
```

### 🔹 For `iptables`

```bash
# Restore saved rules or reboot (if rules are not persistent)
sudo iptables-restore < /etc/iptables/rules.v4  # Debian-based
```

Or reload the firewall configuration script you use.

### 🔹 For `ufw`

```bash
# Re-enable firewall
sudo ufw enable
```

---

Do you want me to generate a shell script that toggles "allow all" and "revert" for convenience?
