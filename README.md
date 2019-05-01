# GalaxyToPulsarInfrastructure
A basic example-infrastructure for submitting jobs from Galaxy->Pulsar->HTCondor.

Usage:
- Set Terraform-Environment-Variables:

      export TF_VAR_cloudflare_email="<EMAIL>"
      export TF_VAR_cloudflare_token="<TOKEN>"
      export TF_VAR_cloudflare_zone="<ZONE>"

- Upload VGCN-Image (https://usegalaxy.eu/static/vgcn/) to OpenStack and change vars.tf accordingly

- Create Infrastructure with Terraform:

      make

- Edit ansible/hosts and ansible/files/galaxy/job_conf.xml to the right hosts

- Install Galaxy

      ansible-playbook galaxy.playbook.yml -i hosts

- Install Pulsar

      ansible-playbook pulsar.playbook.yml -i hosts
