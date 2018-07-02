bastion_IP = 35.204.11.162

someinternalhost_IP = 10.164.0.3

gcloud compute instances create reddit-app-2 \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script= /mnt/c/users/user/documents/otus/task\ 4/vlasovvo_infra/startup-script.sh

gcloud compute firewall-rules create default-puma-server\
 --rules=tcp:9393 \
 --source-ranges=0.0.0.0/0 \
 --target-tags=puma-server

testapp_IP= 35.204.231.87

testapp_port = 9292
