#!/usr/bin/env python3

import os

if 'XDG_CACHE_HOME' in os.environ:
    XDG_CACHE_HOME = os.environ['XDG_CACHE_HOME']
else:
    XDG_CACHE_HOME = os.path.expanduser('~/.cache')
CACHE_DIRECTORY = os.path.join(XDG_CACHE_HOME, 'grip')

here = os.path.dirname(os.path.abspath(__file__))
tokenfile = os.path.join(here, 'token')
if os.path.exists(tokenfile):
    with open(tokenfile) as fp:
        USERNAME = 'zmwangx'
        PASSWORD = fp.read().strip()
