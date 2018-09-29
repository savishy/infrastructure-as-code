# Notes, Tips, Gotchas and Troubleshooting

### `route add` required on Windows 10 for MediaWiki to access MySQL.

I started playing with the MediaWiki Docker container on Docker for Windows 10. I had MySQL running in one Docker container and MediaWiki on another.

[reference](https://github.com/docker/for-win/issues/221).

Specifically for Docker for Windows; to enable the MediaWiki container to access MySQL using its IP, one needs to execute this in an elevated command terminal:

`route /P add 172.0.0.0 MASK 255.0.0.0 10.0.75.2`

Otherwise during MediaWiki setup you won't be able to provide 172.17.0.1 as the IP for MySQL.

### `gather_facts = false` for plays running on localhost.

* I execute Ansible through WSL on Windows
* ChefDK is also installed on Windows.
* Ansible detects that `ohai` is present in the path and tries to use `ohai` to gather facts on localhost - which fails with:

```
fatal: [localhost]: FAILED! => {
    "changed": false,
    "cmd": "/mnt/c/opscode/chefdk/bin/ohai",
    "invocation": {
        "module_args": {
            "fact_path": "/etc/ansible/facts.d",
            "filter": "*",
            "gather_subset": [
                "all"
            ],
            "gather_timeout": 10
        }
    },
    "msg": "[Errno 2] No such file or directory",
    "rc": 2
}
```

As a result I disabled fact gathering for localhost plays.

### Nodes do not have `ansible_default_ipv4` defined which causes `geerlingguy.kubernetes` role to fail.

* The Kubernetes role tries to do a `kubeadm init` and fails with an error.
* The error is on the lines of `ansible_default_ipv4.address is not defined`.

Ref: https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/

This error was because:

* I had set `gather_subset: !ohai` in ansible.cfg for troubleshooting.
* This somehow limited the facts gathered in remote hosts.
* As a result the `ansible_default_ipv4` fact was not being set.
* Removing this fixed the issue.

### `register` stores facts even if a task is skipped, which was causing `geerlingguy.kubernetes` role to behave unexpectedly.

* For tasks that get skipped, the `register` stores the output `skipped`.
* This corrupts the `kubernetes_join_command` variable and the node fails to join the kubernetes cluster.
* Relevant issue https://github.com/ansible/ansible/issues/4297

### Tips to troubleshoot external DB Connectivity

```
# run a ubuntu pod in the cluster.
kubectl run -i --tty ubuntu --image=ubuntu -- bash

# 

root@ubuntu-84bf685985-592gc:/# apt update -qqy  && apt install -y netcat
Setting up netcat (1.10-41.1) ...
root@ubuntu-84bf685985-592gc:/# nc -z mwdbexternal 3306
^C
root@ubuntu-84bf685985-592gc:/# nc -z 10.111.40.92 3306
root@ubuntu-84bf685985-592gc:/# nc -z -v -w5 10.111.40.92 3306
ip-10-111-40-92.ec2.internal [10.111.40.92] 3306 (?) open
root@ubuntu-84bf685985-592gc:/# nc -z -v -w5 54.82.147.250 3306
ec2-54-82-147-250.compute-1.amazonaws.com [54.82.147.250] 3306 (?) : Connection timed out
```
