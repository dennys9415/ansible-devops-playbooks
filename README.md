# Ansible DevOps Playbooks

![Ansible](https://img.shields.io/badge/ansible-%231A1918?style=for-the-badge&logo=ansible&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-blue)
![License](https://img.shields.io/badge/license-MIT-green)

A comprehensive collection of Ansible playbooks for automated server provisioning, configuration management, and application deployment across multiple environments.

## 🚀 Features

- **Multi-Environment Support** - Development, Staging, Production
- **Infrastructure as Code** - Complete server provisioning
- **Security Hardening** - CIS benchmarks and security best practices
- **Monitoring Stack** - Prometheus, Grafana, and Alertmanager
- **Application Deployment** - Docker, Node.js, Python applications
- **Database Management** - PostgreSQL, MySQL, Redis
- **Web Server Setup** - Nginx, Apache with SSL
- **CI/CD Integration** - GitHub Actions with Molecule testing
- **Vault Encryption** - Secure secrets management

## 📋 Prerequisites

### Required Tools

- **Ansible** >= 2.15
- **Python** >= 3.8
- **Molecule** (for testing)
- **Docker** (for local testing)

### Supported Platforms

- Ubuntu 20.04/22.04
- CentOS 7/8
- Debian 11/12
- Amazon Linux 2

## 🏁 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/ansible-devops-playbooks.git
cd ansible-devops-playbooks
```

### 2. Install Dependencies

```bash
# Install Ansible and requirements
./scripts/setup-ansible.sh

# Install Ansible roles
ansible-galaxy install -r requirements.yml
```

### 3. Configure Inventory

```bash
# Copy and edit inventory for your environment
cp inventory/development/hosts inventory/development/hosts.local
# Edit inventory/development/hosts.local with your servers
```

### 4. Run Base Provisioning

```bash
# Provision servers with base configuration
ansible-playbook -i inventory/development/hosts.local playbooks/base-provisioning.yml
```

### 5. Deploy Web Stack

```bash
# Deploy nginx web servers
ansible-playbook -i inventory/development/hosts.local playbooks/webserver-setup.yml

# Deploy PostgreSQL database
ansible-playbook -i inventory/development/hosts.local playbooks/database-setup.yml
```

## 📁 Project Structure

### Simple Structure

```
ansible-devops-playbooks/
├── inventory/           # Environment inventories
├── playbooks/          # Main playbooks
├── roles/              # Reusable roles
├── group_vars/         # Group variables
├── host_vars/          # Host-specific variables
├── files/              # Static files
├── templates/          # Jinja2 templates
├── scripts/            # Utility scripts
├── molecule/           # Role testing
└── tests/              # Integration tests
```

### Entire Structure

```
ansible-devops-playbooks/
├── .github/
│   └── workflows/
│       ├── ansible-lint.yml
│       ├── molecule-tests.yml
│       └── release.yml
├── inventory/
│   ├── production/
│   │   ├── hosts
│   │   └── group_vars/
│   │       ├── all.yml
│   │       ├── webservers.yml
│   │       └── databases.yml
│   ├── staging/
│   │   ├── hosts
│   │   └── group_vars/
│   │       ├── all.yml
│   │       └── webservers.yml
│   └── development/
│       ├── hosts
│       └── group_vars/
│           └── all.yml
├── playbooks/
│   ├── base-provisioning.yml
│   ├── webserver-setup.yml
│   ├── database-setup.yml
│   ├── monitoring-setup.yml
│   ├── security-hardening.yml
│   ├── application-deployment.yml
│   ├── backup-restore.yml
│   └── maintenance-tasks.yml
├── roles/
│   ├── common/
│   │   ├── tasks/
│   │   │   ├── main.yml
│   │   │   ├── users.yml
│   │   │   └── security.yml
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   ├── templates/
│   │   │   ├── motd.j2
│   │   │   └── sshd_config.j2
│   │   ├── files/
│   │   │   └── authorized_keys
│   │   └── defaults/
│   │       └── main.yml
│   ├── nginx/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   ├── templates/
│   │   │   └── nginx.conf.j2
│   │   └── defaults/
│   │       └── main.yml
│   ├── postgresql/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   ├── templates/
│   │   │   └── postgresql.conf.j2
│   │   └── defaults/
│   │       └── main.yml
│   ├── docker/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   └── defaults/
│   │       └── main.yml
│   ├── nodejs/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── handlers/
│   │   │   └── main.yml
│   │   └── defaults/
│   │       └── main.yml
│   └── prometheus/
│       ├── tasks/
│       │   └── main.yml
│       ├── handlers/
│       │   └── main.yml
│       ├── templates/
│       │   └── prometheus.yml.j2
│       └── defaults/
│           └── main.yml
├── group_vars/
│   ├── all.yml
│   ├── webservers.yml
│   ├── databases.yml
│   └── monitoring.yml
├── host_vars/
│   ├── web1.example.com.yml
│   └── db1.example.com.yml
├── files/
│   ├── ssl/
│   │   ├── nginx.crt
│   │   └── nginx.key
│   └── scripts/
│       ├── backup.sh
│       └── health-check.sh
├── templates/
│   ├── nginx-site.conf.j2
│   ├── my.cnf.j2
│   └── application.config.j2
├── scripts/
│   ├── setup-ansible.sh
│   ├── run-playbook.sh
│   ├── inventory-scan.py
│   └── vault-helper.sh
├── molecule/
│   ├── common/
│   │   ├── molecule.yml
│   │   ├── converge.yml
│   │   └── verify.yml
│   └── roles/
│       ├── nginx/
│       │   ├── molecule.yml
│       │   ├── converge.yml
│       │   └── verify.yml
│       └── postgresql/
│           ├── molecule.yml
│           ├── converge.yml
│           └── verify.yml
├── tests/
│   ├── test-common.yml
│   ├── test-webserver.yml
│   └── test-database.yml
├── .ansible-lint
├── .yamllint
├── ansible.cfg
├── requirements.yml
├── vault-password-file
├── README.md
├── LICENSE
└── .gitignore
```

## 🛠️ Playbooks

### Core Playbooks

| Playbook	                    | Description                       |
|-------------------------------|-----------------------------------|
| base-provisioning.yml	        | Base system setup and security    |
| webserver-setup.yml	        | Nginx/Apache with SSL             |
| database-setup.yml	        | PostgreSQL/MySQL databases        |
| monitoring-setup.yml	        | Prometheus + Grafana stack        |
| security-hardening.yml	    | CIS benchmarks & security         |
| application-deployment.yml	| Deploy applications               |
| backup-restore.yml	        | Backup and restore operations     |
| maintenance-tasks.yml	        | System maintenance                |
---

### Environment-Based Deployment

```bash
# Development
ansible-playbook -i inventory/development/hosts playbooks/application-deployment.yml

# Staging
ansible-playbook -i inventory/staging/hosts playbooks/application-deployment.yml

# Production
ansible-playbook -i inventory/production/hosts playbooks/application-deployment.yml
```

## 🔧 Roles

### Available Roles

* common - Base system configuration, users, security

* nginx - Nginx web server with SSL support

* postgresql - PostgreSQL database server

* docker - Docker CE installation and configuration

* nodejs - Node.js runtime environment

* prometheus - Monitoring system with exporters

* grafana - Dashboard and visualization

* redis - Redis caching server

* mysql - MySQL database server

### Using Roles

```yaml
# In your playbook
- hosts: webservers
  roles:
    - role: common
      tags: [base, security]
    - role: nginx
      tags: [webserver, nginx]
    - role: nodejs
      tags: [runtime, nodejs]
```

## 🔒 Security

### Vault Encryption

```bash
# Encrypt sensitive files
ansible-vault encrypt group_vars/production/secrets.yml

# Run playbook with vault
ansible-playbook -i inventory/production/hosts playbooks/deploy.yml --ask-vault-pass

# Or use vault password file
ansible-playbook -i inventory/production/hosts playbooks/deploy.yml --vault-password-file vault-password-file
```

### Security Features

* SSH key-based authentication

* Fail2ban intrusion prevention

* Firewall configuration (UFW/iptables)

* Automated security updates

* CIS benchmark compliance

* SSL/TLS certificate management

## 🧪 Testing

### Molecule Testing

```bash
# Test a specific role
cd roles/nginx
molecule test

# Test all roles
./scripts/run-tests.sh
```
### Linting

```bash
# Ansible linting
ansible-lint playbooks/

# YAML linting
yamllint .

# Playbook syntax check
ansible-playbook --syntax-check playbooks/base-provisioning.yml
```

## 📊 Monitoring

The monitoring playbook deploys:

* Prometheus - Metrics collection

* Grafana - Dashboards and visualization

* Node Exporter - System metrics

* cAdvisor - Container metrics

* Alertmanager - Alerting system

```bash
# Deploy monitoring stack
ansible-playbook -i inventory/production/hosts playbooks/monitoring-setup.yml
```

## 🔄 CI/CD

### GitHub Actions

The repository includes GitHub Actions for:

* Ansible Lint - Code quality checks

* Molecule Tests - Role testing with Docker

* Security Scanning - Vulnerability assessment

* Release Automation - Version tagging

### Workflow Example

```yaml
name: Ansible Lint and Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Ansible Lint
        run: ansible-lint playbooks/ roles/
```

## 🌐 Multi-Cloud Support

### Cloud Providers

* AWS - EC2 instances, security groups

* Google Cloud - Compute Engine, firewall rules

* Azure - VMs, network security groups

* DigitalOcean - Droplets, cloud firewall

### Dynamic Inventory

```bash
# AWS EC2 dynamic inventory
ansible-playbook -i inventory/aws_ec2.yml playbooks/base-provisioning.yml

# Azure dynamic inventory
ansible-playbook -i inventory/azure_rm.yml playbooks/base-provisioning.yml
```

## 🚀 Performance Optimization

### Strategies

* Async operations for long-running tasks

* Fact caching to speed up playbook runs

* Strategic tagging for partial executions

* Parallel execution with forks

* Conditional tasks to skip unnecessary work

### Example

```bash
# Run only security-related tasks
ansible-playbook -i inventory/production/hosts playbooks/security-hardening.yml --tags "security"

# Run with 20 parallel forks
ansible-playbook -i inventory/production/hosts playbooks/base-provisioning.yml -f 20
```

## 🤝 Contributing

1. Fork the repository

2. Create a feature branch (git checkout -b feature/amazing-feature)

3. Commit your changes (git commit -m 'Add amazing feature')

4. Push to the branch (git push origin feature/amazing-feature)

5. Open a Pull Request

Please read CONTRIBUTING.md for details on our code of conduct.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

* Ansible Community for best practices

* Molecule for testing framework

* Contributors and maintainers

## 📞 Support

* Issues: GitHub Issues

* Discussions: GitHub Discussions

* Documentation: Examples and Playbooks