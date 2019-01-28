#!/usr/bin/env python

KEYS = ['A','B','C','D','E','F','G']
VALUES = [0,2,3,5,7,8,10]
OCTECT_RANGE = VALUES[-1] + 2  # 12
BASE_KEYS2VALUES = dict(zip(KEYS, VALUES))

class note(object):
    def __init__(self, key_, cat):
        self.cat = cat  # which octect?
        self.key = key_ + str(cat)
        self.fkey = key_ + str(cat)
        self.value = self.cat*OCTECT_RANGE +  BASE_KEYS2VALUES[key_]
    def __repr__(self):
        return '{}({})'.format(self.fkey, self.value)

val2key = {}
key2val = {}
for c in range(10):
    for n in KEYS:
        nt = note(n,c)
        val2key[nt.value] = nt.fkey
        key2val[nt.fkey] = nt.value



#print len(VALUES)

#print scores
STRING_NUMBER=6
FRET_NUMBER=65
class algorithmic_guitar_hero(object):
    def __init__(self, base_note='A'):
        self.base_line_offset = BASE_KEYS2VALUES[base_note]
    def _create_guitar(self, string_number=STRING_NUMBER, interval = [5, 5, 5, 4, 5]):
        guitar = [[i+self.base_line_offset for i in range(FRET_NUMBER)]]  # base line
        for it in interval:
            new_string = [x+it for x in guitar[-1]]
            guitar.append(new_string)
        return guitar
    def _generate_interval(self):
        VALUES = []
        interval = [0]*5
        i = 0
        def dfs(VALUES, interval, i):
            if i==5:
                VALUES.append(list(interval))
                return
            for k in [4,5,6]:
                interval[i] = k
                dfs(VALUES, interval, i+1)
        dfs(VALUES, interval, i)
        return VALUES
    def _optimize_guitar_design(self):
        max_tot = [[]]
        res = [[]]
        VALUES = self._generate_interval()
        for interval in VALUES:
            guitar = self._create_guitar(interval=interval)
            tot = []
            for k in range(len(guitar[0])):
                full = True
                for j in range(STRING_NUMBER):
                    i = guitar[j][k]
                    s = val2key[i] if i in val2key else str(i)#,'\t',
                    if not s[0].isalpha():
                        full = False
                if full:
                    tot.append(k)
            if len(max_tot[0]) < len(tot):
                max_tot = [tot]
                res = [interval]
            elif len(max_tot[0]) == len(tot):
                max_tot.append(tot)
                res.append(interval)
        return res
    def work(self):
        res = self._optimize_guitar_design()
        schema_num = 1
        for r in res:
            guitar = self._create_guitar(interval=r)
            print "*"*20, " Design Schema ", schema_num, ", Range: ", guitar[-1][-1]-guitar[0][0], "*"*20
            for k in range(len(guitar[0])):
                for j in range(STRING_NUMBER):
                    i = guitar[j][k]
                    s = val2key[i] if i in val2key else str(i)
                    print s, '\t',
                print ""
            print "*"*68
            schema_num += 1

henry = algorithmic_guitar_hero()
henry.work()


