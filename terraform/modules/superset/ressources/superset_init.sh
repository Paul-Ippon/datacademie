#!/usr/bin/bash

install_init() {
    sudo yum update -y
    sudo yum install git -y
}

# Install Docker
install_docker() {
    sudo yum install docker git -y
    service docker start
    usermod -a -G docker ec2-user
    chkconfig docker on
}

# Install docker-compose
install_docker_compose() {
    curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    mv /usr/local/bin/docker-compose /bin/docker-compose
}

install_superset() {
  echo --------------------
  echo -- Instal Superset -
  echo --------------------
  git clone https://github.com/apache/superset.git
  cd superset
  touch ./docker/requirements-local.txt
  echo "snowflake-sqlalchemy" >> ./docker/requirements-local.txt
  sudo docker-compose build --force-rm
}

launch_superset() {
  echo --------------------
  echo -- Launch Superset -
  echo --------------------
  sudo docker-compose -f docker-compose-non-dev.yml pull
  sudo docker-compose -f docker-compose-non-dev.yml up -d
}

main() {
  install_init
  install_docker
  install_docker_compose
  install_superset
  launch_superset
  echo --------------------
  echo ----- All done -----
  echo --------------------
}

main > /tmp/init.log 2>&1
