# 4. GnuPG

Date: 2021-05-26

## Status

Proposed

Amends [3. Development Environment - Secret Management](0003-development-environment-secret-management.md)

## Context

I unwillingly need to use GPG to sign git commits to be able to enable GitHub Vigilant mode, making any unsigned commit show up as unverified.

As the well known [FiloSottile](https://blog.filippo.io/giving-up-on-long-term-pgp/) has mentioned, maintaining long term GPG-keys is a PITA.

I want to use a single yubikey for all my needs, ssh auth, encrypt/decrypt and git commit sign.

GnuPG has an annoying [smartcard exclusive locking-behavior](https://github.com/OpenSC/OpenSC/issues/953), making sharing a single yubikey between host and VMs frustrating.

By either [patching scdaemon](https://github.com/Jehops/freebsd-ports-legacy/commit/1368c2552cb8cd5a1c64f2032366351aae4898cf) or using [gnupg-pkcs11-scd](https://manpages.debian.org/testing/gnupg-pkcs11-scd/gnupg-pkcs11-scd.1.en.html), it might be possible to work around the smartcard locking problems, creating an acceptable compromise between not using hardware tokens and being the guy that decided using two yubikeys is totally fine.

GnuPG 2.3.X seems to bring improvements worth checking out, including `--pcsc-shared`, making the previously mentioned patch unnecessary.

https://gist.github.com/artizirk/d09ce3570021b0f65469cb450bee5e29

https://github.com/NixOS/nixpkgs/pull/121085

https://wiki.archlinux.org/title/GnuPG#Shared_access_with_pcscd

## Considered Options

| Yubikey | # of Yubikeys  | smartcard daemon | scdaemon backend | PIV | Concurrent use host & VM | Setup Eccentricity |
| ------- | -------------- | ---------------- | ---------------- | --- | ------------------------ | ------------------ |
| No      | 0              |                  |                  | No  | Yes                      | 2                  |
| Yes     | 1              | scdaemon         | ccid             | No  | No                       | 3                  |
| Yes     | 2              | scdaemon         | ccid             | No  | Yes                      | 7                  |
| Yes     | 1              | gnupg-pkcs11-scd | pkcs11           | Yes | Maybe                    | 9                  |
| Yes     | 1              | scdaemon         | pcsc / exclusive | No  | Maybe                    | 4                  |
| Yes     | 1              | scdaemon         | pcsc / shared    | No  | Maybe                    | 5                  |

## Decision

The change that we're proposing or have agreed to implement.

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.
