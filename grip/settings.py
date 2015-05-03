#!/usr/bin/env python3

import os

if 'XDG_CACHE_HOME' in os.environ:
    XDG_CACHE_HOME = os.environ['XDG_CACHE_HOME']
else:
    XDG_CACHE_HOME = os.path.expanduser('~/.cache')
CACHE_DIRECTORY = os.path.join(XDG_CACHE_HOME, 'grip')
