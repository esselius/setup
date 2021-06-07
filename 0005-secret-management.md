# 5. Secret Management

Date: 2021-06-05

## Status

Accepted

Supersedes [3. Development Environment - Secret Management](0003-development-environment-secret-management.md)

## Context

Turns out that, if you want to (in a decently secure and seemless way) use GPG /w yubikey + 1pass in a dev VM, you need to:

- Get gnupg running properly (importing your public key and trust it).
- Inject gpg-encrypted versions of your 1pass password + master key and totp secret.

This causes the need for a bootstrapping secret management solution (like sops-nix or agenix), making the use of 1pass itself be a bit redundant and also means that the reason I chose to use 1pass (not needing to reinject secrets on reboot) is inaccurate.

It also turns out that neither of `agenix` or `sops-nix` supports darwin, as they both write the unencrypted secrets to a ram disk mounted at `/run`, which is ensured to not be swapped out to disk, a feature ramdisk or tmpfs does not have on darwin.

The fact that the darwin swap file is encrypted by default, stored on an encrypted APFS partition and the SSD is hardware encrypted by the T2-chip, using a ramdisk which might swap to disk, maybe isn't as bad as it sounds.

Using different solutions for host and dev vm secrets seems to be unavoidable.

Manual on-demand consumption of secrets on the host is acceptable, if injecting secrets in the dev vm is seamless and safe.

### At rest, long term / source of truth

| #   | Long Term Storage | Short Term Storage/Access | Long -> Short Term Convertion | Pros                          | Cons                               |
| :-- | ----------------- | ------------------------- | ----------------------------- | ----------------------------- | ---------------------------------- |
| 1   | 1Password         | age                       | Script                        | Implemented and works, No GPG | Host key rescan on VM reset        |
| 2   | 1Password         | 1pass CLI                 | None                          | Low entropy                   | GPG                                |
| 3   | 1Password         | Pass                      | None                          | Low entrypy, common solution  | GPG                                |
| 4   | 1Password         | Vault @ VM                | Script                        | Fancy, nixos module exists    | High entrypy                       |
| 5   | 1Password         | Vault @ Host              | Script                        | Fancy                         | High entrypy, no nix-darwin module |
| 6   | 1Password         | sops                      | Script                        | Multi-backend                 | GPG, sops-nix < agenix in UX       |

### At rest, short term / what's consumed

| #   | Secret Short Term Storage | Provisioner   | Stored     | Available As                       | Expires At        | Decrypter                        | Pros                          | Cons                         |
| :-- | ------------------------- | ------------- | ---------- | ---------------------------------- | ----------------- | -------------------------------- | ----------------------------- | ---------------------------- |
| 1   | Age                       | agenix        | secrets    | /run/secrets/github_token          | Unused for X time | host ssh key                     | No GPG, Implemented and works |                              |
| 2   | Age                       | nix + wrapper | secrets    | $ agesecret github_token           | Never             | user ssh key                     |                               |                              |
| 3   | 1pass w/ GPG              | nix           | 1pass auth | $ 1pass Github token               | Never             | GPG                              |                               |                              |
| 4   | Pass                      | nix           | secrets    | $ pass show GitHub/token           | Never             | GPG                              |                               |                              |
| 5   | Vault KV                  | nix           | vault auth | $ vault kv get secret/github_token | Never             | Vault Server                     |                               |                              |
| 6   | Vault Transit             | nix + wrapper | vault auth | $ vaultsecret github_token         | Never             | Vault Server                     |                               |                              |
| 7   | Sops + ssh keys           | sops-nix      | secrets    | /run/secrets.d/github_token        | Reboot            | host ssh key turned into gpg key |                               | Annoying UX for key rotation |
| 8   | Sops + Vault              | nix + wrapper | vault auth | $ sopsecret github_token           | Never             | Vault Server                     |                               |                              |

### Transfer

| #   | Secure Introduction              | Secret Transfer Medium         |
| :-- | -------------------------------- | ------------------------------ |
| 1   | None                             | Encrypted blob(s) with secrets |
| 2   | Encrypted Vault auth credentials | Vault TLS                      |
| 3   | Yubikey with GPG                 | Encrypted blob(s) with secrets |
| 4   | Yubikey with PIV                 | Vault TLS                      |
| 5   | Yubikey with PIV                 | Encrypted blob(s) with secrets |
| 6   | Yubikey with GPG                 | 1pass client                   |

## Decision

Use `agenix` as it works and seems safe and flexible enough.

## Consequences

Figure out how to use `agenix` effectively and maintain an on disk ssh key for age encrypt/decrypt, not used for actual SSH.
