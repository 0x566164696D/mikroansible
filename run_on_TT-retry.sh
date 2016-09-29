#!/bin/bash
ansible-playbook -i inventory/hostsTT  TT.yml --limit @/home/mikroansible/ansible/.ansible-retry/TT.retry
