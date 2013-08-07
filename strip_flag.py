#!/usr/bin/env python
#/usr/local/python/bin/python


import os

dir = "/home/aansorge/opg/"
#dir = "/home/ajsorge/opg/"
count = 0

# Read in station metadata
for line in open(dir + "data/snow-inventory.txt"):
  #ID,lat,lon,elv,state,name,gsnf,hcnf.wmoid,method
  mid = line[0:11]
  lat = line[12:20].strip()
  lon = line[21:30].strip()
  #elv = line[31:37]
  #state = line[38:40]
  #name = line[41:71]
  #gsnf = line[72:75]
  #hcnf = line[76:79]
  #wmoid = line[80:85]
  #method = line[86:]

  # Match lat/lon with snow
  for line in open(dir + "data/ann-snow-normal.txt"):
    id = line[0:11]
    snow = line[18:23].strip()
    flag = line[23:].strip()

    # Check to make sure station id of metadata file matches snow data file
    if (mid == id):

      # Quality control flag
      # C=complete; S=standard (<5yr missing); R=representative (interpolate?)
      # P=provisional (at least 10 yrs); Q=quasi-normal (just don't use)
      #if (flag == "C" or flag == "S"):

      # If there is data (-7777 = missing data), add to file
      if (snow != "-7777"):
        # /10 to place into tenths of an inch
        print "Processing %s" % (id)
        snow = str(float(snow)/10.)

        output = open(dir + "data/All_snow_1981_2010.txt","a")
        output.write("%s,%s,%s,%s\n" % (lat,lon,snow,flag) )
        output.close()
      else:
        count += 1

print count
