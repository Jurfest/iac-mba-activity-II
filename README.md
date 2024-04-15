<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" alt="AWS Logo" width="100"/>

  <h1>
    Infrastructure Automation on AWS with 
    <br /> 
    <img align="center" src="https://upload.wikimedia.org/wikipedia/commons/2/24/Ansible_logo.svg" alt="Ansible Logo" width="100"/>
    <br />
    Terraform and Ansible
    <br />
    <img align="center" src="https://www.vectorlogo.zone/logos/terraformio/terraformio-ar21.svg" alt="Terraform Logo" width="100"/>
  </h1>

</div>

This project aims to automate the infrastructure of a startup hosted on AWS, using Terraform and Ansible. The infrastructure consists of EC2 servers for an application that uses MongoDB, Go, and React.

## Objective

Automate the initial configuration of servers, install and configure application dependencies, implement security measures, integrate CI/CD to automatically test and deploy changes to the infrastructure, set up monitoring with CloudWatch and logging with CloudTrail and ELK Stack, and develop playbooks for backup and recovery of critical data.

## How to Use

1. Clone this repository:

```bash
git clone https://github.com/seu-usuario/nome-do-repositorio.git
```

2. Follow the installation and configuration instructions in each directory of the project:

- `terraform/`: Infrastructure configuration with Terraform.
- `ansible/`: Ansible playbooks for configuration and management of the infrastructure.
- `ci-cd/`: Configuration of the CI/CD pipeline for automated testing and deployment.
- `monitoring-logging/`: Configuration of monitoring with CloudWatch and logging with CloudTrail and ELK Stack.
- `backup-recovery/`: Playbooks for backup and recovery of critical data.

## Contributions

Contributions are welcome! Feel free to open issues or pull requests with suggestions, improvements, or fixes.

## License

This project is licensed under the [MIT License](LICENSE).
