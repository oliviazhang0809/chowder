# second
# http://www.kosbie.net/cmu/fall-14/15-112/notes/hw2.html

import math

def nearestLatticePointDistance(x, y):
	lx = round(x)
	ly = round(y)
	a = math.pow(x - lx, 2)
	b = math.pow(y - ly, 2)
	return math.sqrt(a + b)

def digitCount(n):
	if (n == 0): return 1
	n = abs(n)
	count = 0
	while (n > 0):
		count += 1
		n /= 10
	return count

def kthDigits(n, k):
	digit = 0
	n = abs(n)
	while (k >= 0):
		digit = n % 10
		n /= 10
		k -= 1
	return digit

def isPrimeNumber(n):
	if (n == 2): return True
	if ((n < 2) or (n % 2 == 0)): return False
	maxFactor = int(round(n ** 0.5))
	for factor in xrange(3, maxFactor + 1, 2):
		if (n % factor == 0):
			return False
	return True

def isIsolatedPrime(n): # http://en.wikipedia.org/wiki/Twin_prime#Isolated_prime
	if (isPrimeNumber(n) and (not isPrimeNumber(n - 2)) and (not isPrimeNumber(n + 2))):
		print(n)
		return True
	else: return False

def nthNumber(n, f):
	number = 0
	while (n >= 0):
		if (f(number)):
			n -= 1
			if (n < 0):
				return number
		number += 1

def nthIsolatedPrime(n):
	return nthNumber(n, isIsolatedPrime)

def isLeftTrun(n):
	strn = str(n)
	while(len(strn) > 1):
		if not isPrimeNumber(int(strn)):
			return False
		else: strn = strn[1:]
	return isPrimeNumber(int(strn))

def nthLeftTruncatablePrime(n): # http://en.wikipedia.org/wiki/Truncatable_prime
	return nthNumber(n, isLeftTrun)

def carrylessAdd(x, y):
	digit = 1
	res = 0
	while (x > 0 and y > 0):
		number = ((x % 10 + y % 10) % 10) * digit
		res += number
		x /= 10
		y /= 10
		digit *= 10
	while (x > 0):
		res += (x % 10) * digit
		x /= 10
		digit *= 10
	while (y > 0):
		res += (y % 10) * digit
		y /= 10
		digit *= 10
	return res

def carrylessMultiply(x, y): # http://www.maa.org/sites/default/files/pdf/upload_library/2/Applegate-2013.pdf
	if (len(str(x)) > len(str(y))):
		return carrylessMultiply(y, x)
	multiple = 1
	res = 0
	while (x > 0):
		digit = x % 10
		tempY = y
		temp = 0
		yMultiple = 1
		while (tempY > 0):
			digitY = tempY % 10
			number = ((digit * digitY) % 10) * yMultiple
			temp += number
			tempY /= 10
			yMultiple *= 10
		res = carrylessAdd(res, temp * multiple)
		multiple *= 10
		x /= 10
	return res

def longestDigitRun(n):
	last = n % 10
	count = 1
	maxCount = 1
	number = last
	n /= 10
	while (n > 0):
		current = n % 10
		if (current == last):
			count += 1
			if (count > maxCount): 
				maxCount = count
				number = last
		else:
			count = 1
			last = current
		n /= 10
	return (maxCount, number)

def squaresGenerator():
	number = 1
	while True:
		next = int(math.pow(number, 2))
		number += 1
		yield next

def nswGenerator():
	first = 1
	second = 1
	count = 0
	while True:
		if (count < 2):
			count += 1
			yield 1
		else:
			number = first + 2 * second
			yield number
			first = second
			second = number
