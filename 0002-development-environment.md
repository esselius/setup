# 2. Development Environment

Date: 2021-05-23

## Status

Proposed

## Context

I develop and maintain software systems.
I require access to an editor, language runtimes and other tools.

I'm most comfortable with a unix (or unix-like) OS, like MacOS or GNU/Linux.

I want configuration as code because I believe this enables testing and reliable rollback of changes.

I think configuration changes should to be verifiable without causing risk of disrupted work.

## Considered Options

| Description                 | Host OS | Host Config | Dotfiles     | VM OS | VM Engine     | Docker         | Display Mgmt | Pros                      | Cons                         | Score |
| --------------------------- | ------- | ----------- | ------------ | ----- | ------------- | -------------- | ------------ | ------------------------- | ---------------------------- | ----- |
| Mac Laptop w/ NixOS VM      | MacOS   | nix-darwin  | home-manager | NixOS | VMWare Fusion | NixOS          | Great        | 2021 Cfg Mgmt, Native Nix | VM, x11-hell, secret mgmt    | 10    |
| All in NixOS                | NixOS   | nix modules | home-manager |       |               | Native         | Terrible     | Native Nix, No VM         | x11-hell                     | 9     |
| Mac Laptop w/ Docker VM     | MacOS   | nix-darwin  | home-manager |       |               | Docker Desktop | Great        | Just works                | VM, Nix @ Darwin is slipping | 7     |
| Ubuntu Laptop w/ Nix        | Ubuntu  |             | home-manager |       |               | Native         | Terrible     | No VM                     | x11-hell, No System Cfg Mgmt | 4     |
| Mac Laptop w/ Docker VM     | MacOS   | Ansible     | Home Grown   |       |               | Docker Desktop | Great        | Established               | 2015 Cfg Mgmt                | 3     |

## Decision

I will use MacOS with a NixOS in a VM, using my editor and tools all through the normal VM-window.

## Consequences

I need to decide how to do secret management and make my nixos configuration hospitable for every day use