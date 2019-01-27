name = ['A','B','C','D','E','F','G']
scores = [0,2,3,5,7,8,10]
weight = {}
for i in range(len(name)):
    weight[name[i]] = scores[i]

rng = 12

val2name = {}
name2val = {}

class note(object):
    def __init__(self, name_, cat):
        self.cat = cat  # middle
        self.name = name_ + str(cat)
        self.fname = name_ + str(cat)
        self.value = self.cat*rng +  weight[name_]
    def __repr__(self):
        return '{}({})'.format(self.fname, self.value)

for c in range(5):
    for n in name:
        nt = note(n,c)
        #print nt
        val2name[nt.value] = nt.fname
        name2val[nt.fname] = nt.value

for s in [ 'G0', 'B1', 'D1','G1' ,'B2','G2']:
    print name2val[s],

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
            print val2name[i] if i in val2name else i,'\t',
        print "\n"
    """
    tot = []
    for k in range(len(guitar[0])):
        full = True
        for j in range(STRING_NUMBER):
            i = guitar[j][k]
            s = val2name[i] if i in val2name else str(i)#,'\t',
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
            s = val2name[i] if i in val2name else str(i)
            print s, '\t',
        print ""
    print "*"*80


print len(max_tot[0]), max_tot
print res


