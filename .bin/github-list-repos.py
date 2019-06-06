#!/usr/bin/env python3

import os
import sys
from github import Github

if __name__ == '__main__':
    gh = Github(os.environ['GITHUB_TOKEN'])

    for repo in gh.get_user(login=sys.argv[1]).get_repos():
        print(repo.ssh_url)
