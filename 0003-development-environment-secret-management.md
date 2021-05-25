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
I want to avoid this, as it increases the pressure on local security and the risk of accidental exposure.

The NixOS wiki has a [list of common approaches](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes).

I want to be able to restart or reset my machine without reprovisioning secrets.

I want to avoid gpg if possible.

I want to use a yubikey hardware token as a certificate storage for proving my identity.

## Considered Options

## Decision

The change that we're proposing or have agreed to implement.

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.
