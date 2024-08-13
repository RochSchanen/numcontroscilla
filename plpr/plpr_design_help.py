
for j in range(8):

	xy = ""	
	s  = ""
	pi = ""
	po = ""

	for i in range(8):

		if j>i: continue

		xy = f"{i}{j}  {xy}"

		pi = f"P{i+j:02d} {pi}"

		n = j if j < 4 else 3
		m = i-j if i-j < 4 else 3

		s  = f"X{n}{m} {s}"

		po = f"P{2*(7-i):02d} {po}" if i==j else f"    {po}"

	print(xy)
	print(pi)
	print(s)
	print(po)
	print()


