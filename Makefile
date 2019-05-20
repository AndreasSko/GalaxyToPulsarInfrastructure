.PHONY: terraform

rebuild:
	$(MAKE) terraform-rebuild
	sleep 120s
	$(MAKE) ansible

terraform:
	$(MAKE) -C ./terraform main
terraform-rebuild:
	$(MAKE) -C ./terraform rebuild

ansible: galaxy pulsar rabbitmq
galaxy:
	ansible-playbook ansible/galaxy.playbook.yml -i ansible/hosts
pulsar:
	ansible-playbook ansible/pulsar.playbook.yml -i ansible/hosts
rabbitmq:
	ansible-playbook ansible/rabbitmq.playbook.yml -i ansible/hosts
