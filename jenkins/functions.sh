## Get the ips and hostnames
JENKINS_MASTER_HOST_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/jenkins/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.jenkins_master"].primary.attributes.public_dns')
JENKINS_MASTER_HOST_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/jenkins/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.jenkins_master"].primary.attributes.private_dns')
JENKINS_MASTER_IP_PUBLIC=$(cat ../terraform/aws/cloudops-sandbox/jenkins/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.jenkins_master"].primary.attributes.public_ip')
JENKINS_MASTER_IP_PRIVATE=$(cat ../terraform/aws/cloudops-sandbox/jenkins/cloudops-test/terraform.tfstate | jq -r '.modules[0].resources["aws_instance.jenkins_master"].primary.attributes.private_ip')

## prepare HOSTNAME vars
IFS_BAK=$IFS
IFS="."
for word in $JENKINS_MASTER_HOST_PRIVATE; do
  JENKINS_MASTER_HOSTNAME=$word
  break
done
IFS=$IFS_BAK


ARTIFACTS_DIR=$(echo ~)/jenkins
mkdir -p $ARTIFACTS_DIR


## Helper functions
header() {
  echo "*********************"
  echo $1
  echo "*********************"
}

log() {
  echo "- $1"
}

# convert a aws ec2 hostname, e.g. "ip-192-168-0-100" to ip, i.e. 192.168.0.100
hostname_to_ip() {
  hostname=$1
  echo $hostname | sed 's/ip-//' | sed 's/-/./g'
}