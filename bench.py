#!/usr/bin/python3
# file: bench.py
# content: check bench result output
# created: 17 August 2024
# author: roch schanen
# comment:

def expandsign(s, n):
	m = n - len(s)
	if m > 0: return m*s[0]+s
	return s

def sint(s, n = 8):
	if s[0] == '0': return int(expandsign(s, n), 2)
	if s[0] == '1': return int(expandsign(s, n), 2)-(1<<n)

fh = open(".outputs/bench.txt")
ft = fh.read()
fh.close()

lines = ft.split('\n')
headpar = lines[0].split(' ')

if headpar[0] == "plpr":

	size = int(headpar[1].split('=')[1])
	latency = int(headpar[2].split('=')[1])

	DATA = []
	for l in lines[1:]:
		if l:
			a, b, q = l.split(' ')
			DATA.append([
				sint(a, size),
				sint(b, size),
				sint(q, 2*size),
				])

	from numpy import array
	data = array(DATA)

	X, Y, Z = data[:-latency, 0],data[:-latency, 1], data[latency:, 2]

	e = 0
	for i, (x, y, z) in enumerate(zip(X, Y, Z)):
		if x*y == z: continue
		print(f"{x:2} x {y:2} = {x*y:4} = {z}")
		e += 1

	if not e: print("test successful")
