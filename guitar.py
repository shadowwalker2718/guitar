#!/usr/bin/env python

KEYS = ['A','B','C','D','E','F','G']
INTERVALS = [0,2,3,5,7,8,10]
OCTECT_INTERVAL_RANGE = INTERVALS[-1] + 2  # 12
KEYS2INTERVALS = dict(zip(KEYS, INTERVALS))

class note(object):
    def __init__(self, key_, cat):
        self.cat = cat  # middle
        self.key = key_ + str(cat)
        self.fkey = key_ + str(cat)
        self.value = self.cat*OCTECT_INTERVAL_RANGE +  KEYS2INTERVALS[key_]
    def __repr__(self):
        return '{}({})'.format(self.fkey, self.value)

val2key = {}
key2val = {}
for c in range(10):
    for n in KEYS:
        nt = note(n,c)
        val2key[nt.value] = nt.fkey
        key2val[nt.fkey] = nt.value

## G chord
for s in [ 'G0', 'B1', 'D1','G1' ,'B2','G2']:
    print key2val[s],
## C chord
for s in [ 'G0', 'C1', 'E1','G1' ,'C2','E2']:
    print key2val[s],

import sys
sys.exit(0)

def dfs(intervals, interval, i):
    if i==5:
        intervals.append(list(interval))
        return
    for k in [4,5,6]:
        interval[i] = k
        dfs(intervals, interval, i+1)

def generate_interval():
    intervals = []
    interval = [0]*5
    i = 0
    dfs(intervals, interval, i)
    return intervals

intervals = generate_interval()

print len(intervals)

#print scores
BASE_LINE_OFFSET=7
STRING_NUMBER=6
def create_guitar(string_number=STRING_NUMBER, interval = [5, 5, 5, 4, 5]):
    guitar = [[i+BASE_LINE_OFFSET for i in range(13)]]  # base line
    # permutation of [1,2,3,4] of string_number-1 interval
    #interval = [1] *(string_number-1)
    # EADGBE
    #interval = [5, 5, 5, 4, 5]

    for it in interval:
        new_string = [x+it for x in guitar[-1]]
        guitar.append(new_string)
    return guitar

max_tot = [[]]
res = [[]]
for interval in intervals:
    guitar = create_guitar(interval=interval)
    """
    for g in guitar:
        for i in g:
            print val2key[i] if i in val2key else i,'\t',
        print "\n"
    """
    tot = []
    for k in range(len(guitar[0])):
        full = True
        for j in range(STRING_NUMBER):
            i = guitar[j][k]
            s = val2key[i] if i in val2key else str(i)#,'\t',
            if not s[0].isalpha():
                full = False
        #print ""
        if full:
            tot.append(k)
    if len(max_tot[0]) < len(tot):
        max_tot = [tot]
        res = [interval]
    elif len(max_tot[0]) == len(tot):
        max_tot.append(tot)
        res.append(interval)
    #print len(tot), tot



for r in res:
    guitar = create_guitar(interval=r)
    for k in range(len(guitar[0])):
        for j in range(STRING_NUMBER):
            i = guitar[j][k]
            s = val2key[i] if i in val2key else str(i)
            print s, '\t',
        print ""
    print "*"*80


print len(max_tot[0]), max_tot
print res


