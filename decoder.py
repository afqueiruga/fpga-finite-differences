#!/usr/bin/python

#
# Decode hex streams spat out from my FPGA
# afq LBL 2013
#

import numpy as np
import matplotlib.pylab as plt
import re

string  = """
00000000: 00 00 00 00 2c fe 03 00   91 fc 06 00 60 fb 08 00 
00000010: be fa 09 00 be fa 09 00   60 fb 08 00 91 fc 06 00 
00000020: 2c fe 03 00 00 00 00 00   
"""

ll = re.findall(
    "[0-9a-f][0-9a-f] +[0-9a-f][0-9a-f] +[0-9a-f][0-9a-f] +[0-9a-f][0-9a-f]"
    ,string)
#string.split()
print ll

# TODO: CHECK ENDIANNESS???
ll = [ "".join(list(reversed(x.split()))) for x in ll ]

print ll
nums = [ int(st,16) for st in ll ]
print nums

flts = [ float(n)/2**16 for n in nums ]
print flts

plt.plot(flts)
plt.show()
