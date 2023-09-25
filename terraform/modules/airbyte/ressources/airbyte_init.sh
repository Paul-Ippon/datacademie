#!/bin/bash

install_init() {
    sudo yum update -y
}

# Install Docker
install_docker() {
    yum install docker git -y
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

# Install airbyte
install_airbyte() {
    echo --------------------
    echo -- Instal Airbyte --
    echo --------------------
    mkdir airbyte && cd airbyte
    wget https://raw.githubusercontent.com/airbytehq/airbyte/${airbyte_version}/{.env,docker-compose.yaml}
}

# Run airbyte
main() {
  install_init
  install_docker
  install_docker_compose
  install_airbyte
  
  echo ------------------------
  echo -- run docker-compose --
  echo ------------------------
  
  docker-compose up -d

  echo --------------------
  echo ----- All done -----
  echo --------------------
}

main > /tmp/init.log 2>&1
