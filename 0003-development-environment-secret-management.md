# 3. Development Environment - Secret Management

Date: 2021-05-25

## Status

Proposed

Amends [2. Development Environment](0002-development-environment.md)

## Context

In my daily work I need access to personal API tokens and other credentials.

Thinking about when and how you consume secrets is important, given a development environment is where you execute questionable binaries, run  `curl xyz | bash`-oneliners and install the latest HN-inspired tool via `npm install -g qwerty`, which has a non-zero chance of sending my `GITHUB_TOKEN` somewhere in a `postinstall`-script.

Leaking work-related credentials might even be a serious breach of contract with your employer.

As my development environment is set up without manual steps, secrets preferably too should be consumable without manual steps.

When using nix, unless carefully considered, there is risk of secrets ending up unencrypted in the nix-store, ergo readable by all local users.
This should be avoided as it increases the pressure on local security and the risk of accidental exposure.

The NixOS wiki has a [list of common approaches](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes).

I want to be able to restart or reset my NixOS VM without reprovisioning secrets.

I want to avoid gpg if possible, [as it brings it's own baggage](https://blog.filippo.io/giving-up-on-long-term-pgp/).

I want to be able to use my yubikey hardware token for proving my identity and encryption.

Smartcards [work very well](https://archive.fosdem.org/2018/schedule/event/smartcards_in_linux/attachments/slides/2265/export/events/attachments/smartcards_in_linux/slides/2265/smart_cards_slides.pdf) with MacOS and GNU/Linux. [1]

## Considered Options

| Description               | Manual                  | Encrypted at rest       | PIV | GPG | Yubikey SSH | Yubikey Encryption | Yubikey GPG Git Commit Signing | Yubikey x509 Git Commit Signing |
| ------------------------- | ----------------------- | ----------------------- | --- | --- | ----------- | ------------------ | ------------------------------ | ------------------------------- |
| Copy & Paste Tokens + GPG | Yes, on reset & change  | No                      | No  | Yes | Yes         | No                 | Yes                            | No                              |
| Wrap 1pwd CLI + GPG       | No                      | Yes                     | No  | Yes | Yes         | Yes                | Yes                            | No                              |
| Vault-server @ host + PIV | No                      | Yes                     | Yes | No  | Yes         | Yes                | No                             | Yes                             |
| Passwordstore + GPG       | Yes, on change          | Yes                     | No  | Yes | Yes         | Yes                | Yes                            | No                              |
| agenix + GPG              | Yes, on change          | No                      | No  | Yes | Yes         | Yes                | Yes                            | No                              |
| sops-nix + GPG            | Yes, on change          | No                      | No  | Yes | Yes         | Yes                | Yes                            | No                              |

## Decision

The change that we're proposing or have agreed to implement.

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.
