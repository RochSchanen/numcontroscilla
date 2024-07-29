#!/usr/bin/python3
# file: makerom.py
# content: make rom data file for srom.vhd device
# created: 2024 July 29
# author: roch schanen
# comment: use command "python3 makerom.py 8 8"

from sys import version
from sys import argv

print("invoque python3:" + version);

from numpy import pi, sin

AL = int(argv[1])
AS = 2**AL

DL = int(argv[2])
DS = 2**DL-1

fn = f"SIN{AS}x{DL}.txt"

print(f"make {fn}")

fh = open(fn, 'w')
for i in range(AS):
	x = 2*pi / AS * i
	y = (1.0 + sin(x)) / 2.0
	fh.write(f'{int(DS*y):0{DL}b}\n')
# done
fh.close()

# EXAMPLE OUTPUTS:
# > python3 makerom.py 8 8
# invoque Python3:3.10.12 (main, Mar 22 2024, 16:50:05) [GCC 11.4.0]
# make SIN256x8.txt
