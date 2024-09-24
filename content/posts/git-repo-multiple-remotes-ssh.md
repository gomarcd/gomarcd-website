---
title: "Push a Git repo to multiple remotes with unique SSH keys"
date: 2023-02-22
draft: false
---

For one reason or another, you might like to push a Git repo to more than one remote. This website automatically gets pushed to both [Codeberg](https://codeberg.org/gomarcd/gomarcd-website) and [Github](https://github.com/gomarcd/gomarcd-website), for example.

Here, I will discuss how I've set things up.

## Managing multiple SSH keys

With [SSH](https://www.oreilly.com/library/view/ssh-the-secure/0596008953/ch01s01.html), you can securely push changes to your Git remotes without needing to enter login credentials every time. For a single repository, there is minimal setup: just upload your public key.

To use unique keys for different repos calls for a few extra steps.

Create one for Github:

`ssh-keygen -t ed25519 -f ~/.ssh/gomarcd-github`

And another for Codeberg:

`ssh-keygen -t ed25519 -f ~/.ssh/gomarcd-codeberg`

Now let's add an SSH configuration for each one:

```
$ sudo nano ~/.ssh/config

Host gomarcd.github.com
    Hostname github.com
    User gomarcd
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/gomarcd-github
    IdentitiesOnly yes

Host gomarcd.codeberg.org
    Hostname codeberg.org
    User gomarcd
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/gomarcd-codeberg
    IdentitiesOnly yes
```

See the new keypairs with:

```
$ ls ~/.ssh | grep gomarcd

gomarcd-codeberg
gomarcd-codeberg.pub
gomarcd-github
gomarcd-github.pub
```

It's a good idea to back these up in a safe place.

Next, upload each respective **public key** (file ending in **.pub**) to Github & Codeberg.

## Git configuration

Initialize your Git repo and switch to `main` branch:

```
$ cd /home/gomarcd/dev/newProject
$ git init && git branch -m main
```

We switch to `main` because it's often default now, but you should use whatever branch your remote will be expecting.

Make sure Git remote config includes the SSH host:

```
$ nano .git/config

[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        url = git@gomarcd.codeberg.org:gomarcd/newproject.git
        fetch = +refs/heads/*:refs/remotes/origin/*
        url = git@gomarcd.github.com:gomarcd/newproject.git
[branch "main"]
        remote = origin
        merge = refs/heads/main
[user]
        name = gomarcd
        email = git@gomarcd.dev
```

Also note the `gomarcd.github.com` is only a reference to the SSH identity and must match what you put as `Host` from `~/.ssh/config`.

All that's left now is to create a repo with the same name in Github & Codeberg!

From now on, `git push` will automatically push to both repositories using their respective SSH keys.