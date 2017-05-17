df <- read.table("618/indivproject/meteorite2.csv", sep=",",header=TRUE, fill=TRUE,quote="")

library(maps)
library(ggplot2)
ggplot(df, aes(long,lat)) + borders("world") +  geom_point(aes(colour=fall), size=0.1)

#create groups for years
attach(df)
df$year_group[2000 <= year]<-"21st"
df$year_group[2000 > year & year >= 1900]<-"20th"
df$year_group[1900>year & year>=1800]<-"19th"
df$year_group[1800>year & year>=1700]<-"18th"
df$year_group[1700>year & year>=1600]<-"17th"
df$year_group[1600>year & year>=1500]<-"16th"
df$year_group[1500>year]<-"pre-16th"
detach(df)

ggplot(df, aes(long,lat)) + borders("world") +  geom_point(aes(colour=year_group,shape=fall), size=0.1)

##subsetting by fall, found, because to include both in one vis is too hard to read
found<-subset(df, fall=="Found")
fell<-subset(df, fall=="Fell")

found<-ggplot(found, aes(long,lat)) + borders("world") +  geom_point(aes(colour=year_group),size=.1)+ggtitle("Found")
fell<-ggplot(fell, aes(long,lat)) + borders("world") +  geom_point(aes(colour=year_group),size=.5)+ggtitle("Fell")
fell
found
summary(df)

##checked against original dataset, only 75 relict
##similarly, only 1107 fell in original dataset

df$class_2 <-"NA"

##order of statements below is important
##this one works!
##http://stackoverflow.com/questions/35233744/create-new-column-from-an-existing-column-with-pattern-matching-in-r

df$class_2[grepl("Iron ungrouped", df$recclass, ignore.case = TRUE)] <-  "ungrouped iron"
df$class_2[grepl("Pallasite", df$recclass, ignore.case = TRUE)] <-  "pallasites"
df$class_2[grepl("Acapulcoite", df$recclass, ignore.case = TRUE)] <-  "achondrites"
df$class_2[grepl("Achondrite|Angrite|Aubrite|Brachinite|Diogenite", df$recclass, ignore.case = TRUE)] <-  "achondrites"
df$class_2[grepl("C", df$recclass, ignore.case = FALSE)] <-  "chondrites"
df$class_2[grepl("E", df$recclass, ignore.case = FALSE)] <-  "chondrites"
df$class_2[grepl("Eucrite", df$recclass, ignore.case = TRUE)] <-  "achondrites"
df$class_2[grepl("Fusion crust", df$recclass, ignore.case = TRUE)] <-  "unknown"
df$class_2[grepl("H", df$recclass, ignore.case = FALSE)] <-  "chondrites"
df$class_2[grepl("Howardite", df$recclass, ignore.case = FALSE)] <-  "achondrites"
df$class_2[grepl("K|L", df$recclass, ignore.case = FALSE)] <-  "chondrites"
df$class_2[grepl("Lodranite|Lunar|Martian", df$recclass, ignore.case = FALSE)] <-  "achondrites"
df$class_2[grepl("Mesosiderite", df$recclass, ignore.case = FALSE)] <-  "mesosiderites"
df$class_2[grepl("R", df$recclass, ignore.case = FALSE)] <-  "chondrites"
df$class_2[grepl("Relict iron", df$recclass, ignore.case = FALSE)] <-  "ungrouped iron"
df$class_2[grepl("Stone", df$recclass, ignore.case = FALSE)] <-  "ungrouped stone"
df$class_2[grepl("Ureilite|Winonaite", df$recclass, ignore.case = FALSE)] <-  "achondrites"
df$class_2[grepl("Pallasite PES", df$recclass, ignore.case = FALSE)] <-  "pallasites"
df$class_2[grepl("Iron", df$recclass, ignore.case = TRUE)] <-  "ungrouped iron"
df$class_2[grepl("Iron IAB", df$recclass, ignore.case = TRUE)] <-  "non-magmatic"
df$class_2[grepl("Iron IIE", df$recclass, ignore.case = TRUE)] <-  "non-magmatic"
df$class_2[grepl("Iron IC|Iron IIAB|Iron IIC|Iron IID|Iron IIF|Iron IIG|Iron IIIAB|Iron IIIE|Iron IIIF|Iron IVA|Iron IVB", df$recclass, ignore.case = TRUE)] <-  "magmatic"


##troubling because chondrites still dominate. may need to split this group
qplot(lat,long,data=subset(df, 0<mass& mass<1750000), facets=~class_2, color=year_group)

##QUESTION 3
#basicially just showing yes, dramatic increase in # of meteorites
#histogram seems more helpful
qplot(year_group, data=df)+ggtitle("Meteorite Counts")
ggplot(data=df, aes(x=year, y=..count.., color=class_2)) +geom_line(stat="bin")+ggtitle("Meteorite Counts by Class_2")

#"landing" site
#maybe not appropriate use of stat_smooth--at any rate, this seems like the most interesting
#and maybe only info we can get from this dataset, where meteorites land (pattern or no)
qplot(lat,long, data=df)+stat_smooth()


##reduce data set for line chart
reduced <- subset(df, class_2 !="unknown"& class_2!="ungrouped stone"& class_2!="ungrouped iron")
reduced <- subset(reduced, year>1800)
ggplot(data=df, aes(x=year, y=..count.., color=class_2)) +geom_point(stat="bin") 
ggplot(data=reduced, aes(x=year, y=..count.., color=class_2)) +geom_point(stat="bin") 
ggplot(data=reduced, aes(x=year, y=..count.., color=class_2)) +geom_line(stat="bin")+ylim(c(0,2500))+ggtitle("Reduced Count by Year Chart--Line")
ggplot(data=reduced, aes(x=year, y=..count.., color=class_2)) +geom_point(stat="bin") +ylim(c(0,2500))+ggtitle("Reduced Count by Year Chart--Scatterplot")