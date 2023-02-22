---
title: "Push a Git repo to multiple remotes with unique SSH keys"
date: 2023-02-17
draft: false
---

For one reason or another, you might like to push a Git repo to more than one remote. This website itself for example, automatically gets pushed to both [Codeberg](https://codeberg.org/gomarcd/gomarcd-website) and [Github](https://github.com/gomarcd/gomarcd-website).

Here, I will discuss how I've set things up.

## SSH keys

[SSH](https://www.oreilly.com/library/view/ssh-the-secure/0596008953/ch01s01.html) is something of a staple in IT; system administration & devops in particular. Administrators use SSH to securely access remote servers, and software developers use it to securely push changes from their local machines into places like Github without needing to enter login credentials every time.