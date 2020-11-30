#!/usr/bin/env bash

[[ "${TRACE}" ]] && set -x
set -eou pipefail
shopt -s nullglob

main() {
    case "$(uname -s)" in
    Darwin)
        ./mac/provision.sh "$@"
        ;;
    Linux)
        case "$(uname -r)")
            *Microsoft)
                ./win/provision.sh "$@"
                ;;
            *)
                ./linux/provision.sh "$@"
                ;;
        esac
        ;;
    *)
        echo "Unknown OS" >&2
        return 1
        ;;
    esac
}

main "$@"
