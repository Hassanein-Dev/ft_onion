# ft_onion - Tor Hidden Service Project

This project creates a web page accessible through the Tor network as a hidden service (.onion address).

## 📋 Project Overview

This implementation creates:
- A **static web page** served via Nginx
- A **Tor hidden service** that exposes the web page on the .onion network
- **SSH access** on port 4242 through the Tor network
- All configurations properly documented and ready to use

## 📁 Project Files

- `index.html` - The static web page displayed on the hidden service
- `nginx.conf` - Nginx web server configuration
- `torrc` - Tor configuration for the hidden service
- `sshd_config` - SSH server configuration for port 4242
- `README.md` - This documentation file

## 🚀 Quick Setup Guide

### Prerequisites

You need a Linux system (Debian/Ubuntu recommended) with:
- Nginx
- Tor
- SSH server

### Installation Steps

#### 1. Install Required Packages

```bash
sudo apt update
sudo apt install -y nginx tor openssh-server
```

#### 2. Deploy Configuration Files

```bash
# Copy nginx configuration
sudo cp nginx.conf /etc/nginx/nginx.conf

# Copy the web page
sudo mkdir -p /var/www/html
sudo cp index.html /var/www/html/

# Copy Tor configuration
sudo cp torrc /etc/tor/torrc

# Copy SSH configuration
sudo cp sshd_config /etc/ssh/sshd_config
```

#### 3. Set Proper Permissions

```bash
# Set ownership for web files
sudo chown -R www-data:www-data /var/www/html/

# Create Tor hidden service directory
sudo mkdir -p /var/lib/tor/hidden_service
sudo chown -R debian-tor:debian-tor /var/lib/tor/hidden_service
sudo chmod 700 /var/lib/tor/hidden_service
```

#### 4. Start Services

```bash
# Restart Nginx
sudo systemctl restart nginx

# Restart Tor
sudo systemctl restart tor

# Restart SSH
sudo systemctl restart ssh
```

#### 5. Get Your .onion Address

```bash
# Wait a few seconds for Tor to generate the hidden service
sleep 5

# Display your .onion address
sudo cat /var/lib/tor/hidden_service/hostname
```

This will output something like: `xxxxxxxxxxxxxxxxx.onion`

## 🧪 Testing

### Test the Web Server Locally

```bash
# Check if Nginx is serving the page
curl http://localhost
```

### Access via Tor Browser

1. Download and install [Tor Browser](https://www.torproject.org/download/)
2. Open Tor Browser
3. Enter your `.onion` address in the URL bar
4. You should see your web page!

### Test SSH Access

From another machine with Tor installed:

```bash
# Using torify to route SSH through Tor
torify ssh -p 4242 username@your-address.onion
```

Or configure SSH to use Tor proxy:

```bash
# Install torsocks if needed
sudo apt install torsocks

# Connect via SSH
torsocks ssh -p 4242 username@your-address.onion
```

## 🔍 Verification Checklist

- [ ] Nginx is running and serving on port 80
- [ ] Tor service is running
- [ ] Hidden service directory exists with hostname file
- [ ] SSH is listening on port 4242
- [ ] Web page is accessible via .onion address in Tor Browser
- [ ] SSH connection works through Tor (optional)

## 🛠️ Troubleshooting

### Nginx won't start

```bash
# Check nginx configuration
sudo nginx -t

# Check error logs
sudo tail -f /var/log/nginx/error.log
```

### Tor won't start

```bash
# Check Tor logs
sudo journalctl -u tor -f

# Verify torrc syntax
sudo tor --verify-config -f /etc/tor/torrc
```

### Can't find .onion address

```bash
# Check if Tor generated the hostname
sudo ls -la /var/lib/tor/hidden_service/

# Check Tor status
sudo systemctl status tor
```

### SSH not working on port 4242

```bash
# Check SSH configuration
sudo sshd -t

# Check if SSH is listening on port 4242
sudo netstat -tlnp | grep 4242

# Or with ss
sudo ss -tlnp | grep 4242
```

## 🔒 Security Notes

### SSH Hardening (Bonus)

The `sshd_config` includes several security enhancements:
- SSH runs on non-standard port 4242
- Root login disabled
- Strong ciphers and key exchange algorithms
- Limited authentication attempts
- Automatic disconnect of inactive sessions

### Additional Hardening (Optional)

For even better security:

1. **Disable password authentication** (use keys only):
   ```bash
   # In sshd_config, change:
   PasswordAuthentication no
   ```

2. **Enable fail2ban**:
   ```bash
   sudo apt install fail2ban
   ```

3. **Use firewall rules** (if needed):
   ```bash
   sudo ufw allow 4242/tcp
   sudo ufw allow 80/tcp
   sudo ufw enable
   ```

## 📚 Understanding the Setup

### How it Works

1. **Nginx** serves your `index.html` on `localhost:80`
2. **Tor** creates a hidden service that:
   - Generates a unique `.onion` address
   - Routes incoming requests from Tor network to `localhost:80`
   - Also routes SSH traffic to `localhost:4242`
3. **SSH** listens on port 4242 for secure remote access

### The Tor Hidden Service

- Your `.onion` address is generated from cryptographic keys
- It's stored in `/var/lib/tor/hidden_service/hostname`
- The private key is in `/var/lib/tor/hidden_service/ht_ed25519_secret_key`
- **Never share the private key!**

### No Port Forwarding Required

As per project requirements, you don't need to:
- Open ports in your firewall
- Configure port forwarding
- Have a public IP address

Tor handles all the networking through its onion routing protocol!

## 🎯 Project Compliance

This implementation satisfies all mandatory requirements:

✅ Static web page (index.html)  
✅ Nginx web server  
✅ HTTP access on port 80  
✅ SSH access on port 4242  
✅ No port forwarding or firewall configuration needed  
✅ All required configuration files provided  

## 🎁 Bonus Features

- SSH fortification with modern security standards
- Attractive, responsive web design
- Comprehensive documentation
- Easy-to-follow setup process

---

**Stay Anonymous, Stay Free! 🧅**
