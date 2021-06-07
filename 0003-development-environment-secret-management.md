# 3. Development Environment - Secret Management

Date: 2021-05-26

## Status

Accepted

Amends [2. Development Environment](0002-development-environment.md)

Amended by [4. GnuPG](0004-gnupg.md)

Superseded by [5. Secret Management](0005-secret-management.md)

## Context

In my daily work I need access to personal API tokens and other credentials.

Thinking about when and how you consume secrets is important, given a development environment is where you execute questionable binaries, run  `curl xyz | bash`-oneliners and install the latest HN-inspired tool via `npm install -g qwerty`, which has a non-zero chance of sending my `GITHUB_TOKEN` [somewhere in a postinstall-script](https://duo.com/decipher/hunting-malicious-npm-packages).

Leaking work-related credentials might even be a serious breach of contract with your employer.

As my development environment setup is automated, secrets too needs be made available without extra steps.

When using nix, unless carefully considered, there is risk of secrets ending up unencrypted in the nix-store, ergo readable by all local users.
This should be avoided as it increases the pressure on local security and the risk of accidental exposure.

The NixOS wiki has a [list of common approaches](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes).

I want to be able to restart or reset my NixOS VM without reprovisioning secrets.

I want to avoid gpg if possible, [as it brings it's own baggage](https://blog.filippo.io/giving-up-on-long-term-pgp/).

I want to be able to use my yubikey hardware token for proving my identity and encryption.

Smartcards [work very well](https://archive.fosdem.org/2018/schedule/event/smartcards_in_linux/attachments/slides/2265/export/events/attachments/smartcards_in_linux/slides/2265/smart_cards_slides.pdf) with MacOS and GNU/Linux.

I want to enable [github vigilant mode](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/displaying-verification-statuses-for-all-of-your-commits#about-vigilant-mode) and therefore need either GPG or S/MIME commit signing.

I haven't managed to find a way to get hold of a S/MIME x509 certificate which GitHub finds pleasing yet (tried free Actalis and $30 ssl.com).

This [GPG-protected 1password cli](https://github.com/dcreemer/1pass) might provide a decent experience.

GnuPG has an annoying smartcard exclusive locking-behavior, which also makes sharing a single yubikey between host and VMs frustrating.

## Considered Options

| Description               | Manual                  | Encrypted at rest       | PIV | GPG | Yubikey SSH | Yubikey Encryption | Yubikey GPG Git Commit Signing | Yubikey x509 Git Commit Signing |
| ------------------------- | ----------------------- | ----------------------- | --- | --- | ----------- | ------------------ | ------------------------------ | ------------------------------- |
| Copy & Paste Tokens + GPG | Yes, on reset & change  | No                      | No  | Yes | Yes         | No                 | Yes                            | No                              |
| 1pass CLI + GPG           | If cached, on change    | Yes                     | No  | Yes | Yes         | Yes                | Yes                            | No                              |
| Vault-server @ host + PIV | Yes, on change          | Yes                     | Yes | No  | Yes         | Yes                | No                             | Yes                             |
| Passwordstore + GPG       | Yes, on change          | Yes                     | No  | Yes | Yes         | Yes                | Yes                            | No                              |
| agenix + GPG              | Yes, on change          | No                      | No  | Yes | Yes         | Yes                | Yes                            | No                              |
| sops-nix + GPG            | Yes, on change          | No                      | No  | Yes | Yes         | Yes                | Yes                            | No                              |

## Decision

Unless I get hold of a S/MIME certificate for signing commits, GPG seems to be hard to avoid in practice and fetching secrets directly from 1password induces the least amounts of management overhead.

I will use `1pass CLI + GPG`.

## Consequences

I will need to figure out how to use GPG with a single yubikey at the same time from the host and VM.
