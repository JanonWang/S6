# S6 Installation Guide (Ubuntu 16.04)
## Step 1: Install prerequisite software
```
sudo apt install python
sudo apt install build-essential
sudo apt install python-clang-3.6
sudo apt install libclang-3.6-dev
sudo apt install libpcre3-dev
sudo apt install unzip
```

## Step 2: In S6 project root, run:
```
./build.py build deps
```

## Step 3: Install BESS
### Step3.1: clone bess repo
```
git clone https://github.com/NetSys/bess.git
```

### Step3.2: Install prerequisite software
```
sudo apt install make apt-transport-https ca-certificates g++ make pkg-config libunwind8-dev liblzma-dev zlib1g-dev libpcap-dev libssl-dev libnuma-dev git python python-pip python-scapy libgflags-dev libgoogle-glog-dev libgraph-easy-perl libgtest-dev libgrpc++-dev libprotobuf-dev libc-ares-dev libgtest-dev

sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
ansible-playbook -i localhost, -c local env/build-dep.yml  # This step fails when ansible excute "Install gRPC and its requirements (from source)" due to the GreatWall firewall in China. Thus, we delelte the block named "Install gRPC and its requirements (from source)" in build-dep.yml and install gRPC manually using the following commands
# ------- Start installing gRPC manually --------
sudo apt-get install -y autoconf libtool cmake
cd /tmp && git clone --recurse-submodules -j4 https://github.com/google/grpc
cd grpc && make -j`nproc` EXTRA_CFLAGS='-Wno-error' HAS_SYSTEM_PROTOBUF=false
make install
cd ./third_party/protobuf && make install
cd ../benchmark && cmake . && make install
ldconfig
# ------- Finish install gRPC --------
ansible-playbook -i localhost, -c local env/runtime.yml  # if you want to run BESS on the same machine.
sudo reboot
```

### Step3.3: Start huge pages everytime you reboot
```
echo 1024 | sudo tee /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
echo 1024 | sudo tee /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages
```

### Step3.4: Link proper g++ version (need g++ version 7)
```
ls -lah /usr/bin/g++*  # check g++ binaries you have
sudo rm /usr/bin/g++ 
sudo ln -s /usr/bin/g++-7 /usr/bin/g++
```

### Step3.5: Build! (in BESS project root)
```
./build.py
```

### Step3.6: Make you have bess running before starting S6
```
./bessctl/bessctl
> daemon start
```

## Step 4: Build S6! (In S6 project root):
```
./build.py
```

## Step 5: Create ssh key for S6:
- use ssh-keygen to generate a new ssh key called: id_rsa
- add public key to ~/.ssh/authorized_keys
- copy private key to S6/s6ctl/host_config/

## Step 6: Docker:
### Step 6.1: Install Docker
Follow this link: <https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce>
### Step 6.2: configure to run docker without sudo
```
sudo usermod -aG docker $USER
```

## Step 7: Run S6!
```
./s6ctl/s6ctl
```
