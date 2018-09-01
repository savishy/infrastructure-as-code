# Notes, Tips, Gotchas and Troubleshooting

### `route add` required on Windows 10 for MediaWiki to access MySQL.

I started playing with the MediaWiki Docker container on Docker for Windows 10. I had MySQL running in one Docker container and MediaWiki on another.

[reference](https://github.com/docker/for-win/issues/221).

Specifically for Docker for Windows; to enable the MediaWiki container to access MySQL using its IP, one needs to execute this in an elevated command terminal:

`route /P add 172.0.0.0 MASK 255.0.0.0 10.0.75.2`

Otherwise during MediaWiki setup you won't be able to provide 172.17.0.1 as the IP for MySQL.

### `gather_subset = !ohai` in ansible.cfg

This is needed because I execute Ansible through WSL on Windows, and ChefDK is also installed. Ansible detects that `ohai` is present and tries to use `ohai` to gather facts - which fails with:

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

I do not want Ansible to use Ohai to gather facts about localhost, so I disable ohai in ansible.cfg.
