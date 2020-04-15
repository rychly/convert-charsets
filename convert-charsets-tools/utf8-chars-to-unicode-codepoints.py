#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from __future__ import print_function
import io
import re
import sys

with io.open(sys.argv[1] if len(sys.argv) > 1 else 0, mode = 'r', encoding = 'utf-8') as file:
	for line in file:
		encoded = line.encode('ascii', 'backslashreplace')
		replaced_single = re.sub(r'"\\x([0-9a-f]{2})"', r'0x00\1', encoded)
		replaced_double = re.sub(r'"\\u([0-9a-f]{4})"', r'0x\1', replaced_single)
		print(replaced_double, end='')
