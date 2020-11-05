# kubernetes-lab

# Prerequisites

## VM Hardware Requirements

8 GB of RAM (preferably 16 GB)
50 GB Disk space

## VMware Workstation Player

Download and Install VMware Workstation Player/VirtualBox

## Vagrant

Once VMware Workstation Player/VirtualBox is installed you can deploy virtual machines manually.
Vagrant provides an easier way to deploy multiple virtual machines on VMware Workstation Player/VirtualBox in an automated manner.

Download and Install [Vagrant](https://www.vagrantup.com/).

## Provisioning Resources

CD into vagrant directory

`cd kubernetes-lab/Vagrant`

Run Vagrant up

`vagrant up`


This does the below:

- Deploys 5 VMs - 2 Masters, 2 Workers, and 1 Load-balancer with names 'kubernetes-lab-* '
    > These are the default settings. They can be changed at the top of the Vagrant file.

- Set's IP addresses in the range 192.168.5

    | VM            |  VM Name                | Purpose       | IP           | Forwarded Port   |
    | ------------  | ----------------------- |:-------------:| ------------:| ----------------:|
    | master-1      | kubernetes-lab-master-1 | Master        | 192.168.5.11 |     2711         |
    | master-2      | kubernetes-lab-master-2 | Master        | 192.168.5.12 |     2712         |
    | worker-1      | kubernetes-lab-worker-1 | Worker        | 192.168.5.21 |     2721         |
    | worker-2      | kubernetes-lab-worker-2 | Worker        | 192.168.5.22 |     2722         |
    | load-balancer | kubernetes-lab-lb       | LoadBalancer  | 192.168.5.30 |     2730         |

    > These are the default settings. These can be changed in the Vagrant file.

- Adds a DNS entry to each of the nodes to access internet
    > DNS: 8.8.8.8

- Installs Docker on Worker nodes
- Runs the below command on all nodes to allow for network forwarding in IP Tables.
  This is required for kubernetes networking to function correctly.
    > sysctl net.bridge.bridge-nf-call-iptables=1

## SSH to the nodes

There are two ways to SSH into the nodes:

### 1. SSH using Vagrant

  From the directory you ran the `vagrant up` command, run `vagrant ssh <vm>` for example `vagrant ssh master-1`.
  > Note: Use VM field from the above table and not the vm name itself.

### 2. SSH Using SSH Client Tools

Use your favourite SSH Terminal tool (putty).

Use the above IP addresses. Username and password based SSH is disabled by default.
Vagrant generates a private key for each of these VMs. It is placed under the .vagrant folder (in the directory you ran the `vagrant up` command from) at the below path for each VM:

**Private Key Path:** `.vagrant/machines/<machine name>/virtualbox/private_key`

**Username:** `vagrant`


## Verify Environment

- Ensure all VMs are up
- Ensure all VMs are assigned the above IP addresses
- Ensure you can SSH into these VMs using the IP and private keys
- Ensure the VMs can ping each other
- Ensure the worker nodes have Docker installed on them. Version: 18.06
  > command `sudo docker version`