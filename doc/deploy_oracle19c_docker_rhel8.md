# Deployment: Dcokerize Oracle 19c on RHEL 8

[Back](../README.md)

- [Deployment: Dcokerize Oracle 19c on RHEL 8](#deployment-dcokerize-oracle-19c-on-rhel-8)
  - [Install Docker package](#install-docker-package)

---

## Install Docker package

```sh
# install docker
sudo dnf remove -y docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine \
    podman \
    runc

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker Engine.
sudo systemctl enable --now docker
# Verify
sudo docker run hello-world
```

- Install Git and Clone Oracle official git project

````sh

```sh
dnf install git

mkdir -pv /root/oracledb_docker

git clone https://github.com/oracle/docker-images.git /root/oracledb_docker
````

- Build docker image

```sh
# Navigate to the path
cd /root/oracledb_docker/OracleDatabase/SingleInstance/dockerfiles

# copy binary zip file to the version folder
ll /root/oracledb_docker/OracleDatabase/SingleInstance/dockerfiles/19.3.0/LINUX.X64_193000_db_home.zip

# run build container script
./buildContainerImage.sh -v 19.3.0 -e -t oracledb:1.0
# -e: creates image based on 'Enterprise Edition'
# -t: image_name:tag for the generated docker image
# note: The container needs at least 18 GB

# confirm
docker images
# REPOSITORY    TAG       IMAGE ID       CREATED              SIZE
# oracledb      1.0       3d4eec6ec3c3   About a minute ago   6.5
```

- Run docker container

```sh
# run docker container
docker run -d -it --name oracledbcon \
    -p 1521:1521 \
    -p 5500:5500 \
    -e ORACLE_PDB=pdb1 \
    -e ORACLE_PWD=Password1! \
    -v oracledata:/opt/oracle/oradata \
    oracledb:1.0
```

- Push to docker hub

```sh
# tag the image and push to the hub
docker push simonangelfong/database-repo:v1.0
```

- Run the container using the image

```sh
docker run -d -it --name oracledbcon -p 1521:1521 -p 5500:5500 -e ORACLE_PDB=pdb1 -e ORACLE_PWD=SecurePassword!234 -v oracledata:/opt/oracle/oradata simonangelfong/database-repo:v1.0
```
