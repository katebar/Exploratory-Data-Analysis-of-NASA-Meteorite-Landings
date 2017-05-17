import re
import csv

input = open ('meteorite.csv', 'rU')


structure_1=[]
count= 0
for line in input:
    #remove newline
    line=line.rstrip()
    # delete geolocation
    line =re.sub(',"\(.+,.+\)"','', line)
    line=line.split(',')
    #remove blanks
    if '' in line:
        pass
    else:
        structure_1.append(line)
        count = count + 1

print "structure_1 ",len(structure_1)

counts=0

structure_2=[]
for thing in structure_1:
    counts=counts+1
    if len(thing)==9:
        structure_2.append(thing)
    else:
        thing[3:5] = [''.join(thing[3:5])]
        structure_2.append(thing)

structure_3=[]

#convert mass, lat and long to float types
for line in structure_2:
    try:
        line[4]=float(line[4])
        line[7]=float(line[7])
        line[8]=float(line[8])
    except:
        continue

print "structure_2",counts

finalcounts=0

#remove entries where lat/long is 0,0
for thing in structure_2:
    if thing[7]==0 and thing[8]==0:
        pass
    else:
        structure_3.append(thing)
        finalcounts=finalcounts+1

print "structure_3 ",finalcounts

count4=0
structure_4=[]

#clean year data
for line in structure_3:
    try:
        line[6] = re.sub('[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\s[A-Za-z][A-Za-z]', '', line[6])
        line[6]=re.sub('[0-9]+\/','',line[6])
        line[6] = int(line[6])

    except:
        pass

#remove bad years
for line in structure_3:
    if line[6]<=860 or line[6]>2016:
        pass
    else:
        structure_4.append(line)
        count4=count4+1

print "final count: ",count4

with open('meteorite2.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(['name', 'id', 'type', 'recclass','mass','fall','year','lat','long'])
    writer.writerows(structure_4)