#
# File Name Makefile
# By Evan Foss
# Date 2010.05.07
# Project 
#
# Description
# 
#
# Requirements
#
#

#Project Name
NAME = liplight
#Project Schematics
SCHEMATICS = ledarray-lip.sch ledarray-red.sch ledarray-green.sch rampgen.sch hidden-magic.sch
#Project Netlists
NETLISTS = $(NAME).net
#Project SPICE Simulation Data
SPICEDATA = $(NAME).dat
#Project SPICE Data to Graph
SPICEGRAPH = $(NAME)SPICE.csv
#Project GNUCAP Simulation Data

#Project GNUCAP Data to Graph

#Project Graphing Programs
GRAPHCMDFILE_GNUPLOT = plot.gnu
#Project Schematics to PCB File
SCH2PCB = project.lht
#Project Printed Circuit Boards
PCBS = liplight-art.lht
#Project Gerbers
GERBERS = $(PCBS).fab.gbr $(PCBS).plated-drill.cnc $(PCBS).topsilk.gbr $(PCBS).top.gbr $(PCBS).topmask.gbr $(PCBS).group1.gbr $(PCBS).group2.gbr $(PCBS).bottomsilk.gbr $(PCBS).bottom.gbr  $(PCBS).bottommask.gbr

#
## Text Editor
TEXTEDITOR = vi
#
## Math Tool (you still have to type notebook() after this starts though)
MATHTOOL = sage
MATHFLAGS = 
#
## Schematic Capture
SCHTOOL = gschem
SCHFLAGS = -q
#
## Schematic Library
SCHLIB = gschlas
SCHLIBFLAGS = -e
#
## Simulation Tool
SIMTOOL = ngspice
SIMFLAGS = -n -b
#
## Netlist Generator
NETTOOL = gnetlist
NETFLAGS = -g spice-sdb -o 
NETDRC = -g drc2 -o drcerrors-tmp.text
#
## Graphing Tool
GRAPHTOOL_GNUPLOT = gnuplot
GRAPHFLAGS_GNUPLOT = -persist
#
## Schematic to PCB Tool
SCH2PCBTOOL = gsch2pcb-rnd
# 
# PCB Tool
PCBTOOL = pcb-rnd
#
# Gerber Viewer
PCBVIEW = gerbv

all:
	$(TEXTEDITOR) Makefile

change:
	$(SCHTOOL) $(SCHFLAGS)  $(SCHEMATICS)

simulation:
	$(NETTOOL) $(NETFLAGS) $(NETLISTS) $(SCHEMATICS)
	cat $(NETLISTS)
	$(SIMTOOL) $(SIMFLAGS) $(NETLISTS) -o $(SPICEDATA)
	./stripper.pl > $(SPICEGRAPH)

graph:
	$(GRAPHTOOL_GNUPLOT) $(GRAPHFLAGS_GNUPLOT) $(GRAPHCMDFILE_GNUPLOT)

math:
	$(MATHTOOL) $(MATHFLAGS)

sch2pcb:
	$(SCH2PCBTOOL) -m import $(SCH2PCB) 

pcb:    sch2pcb
	$(PCBTOOL) $(PCBS)

gerbv:
	$(PCBVIEW) $(PCBVIEWFLAGS) $(GERBERS)

alberta:
	mv $(PCBS).frontsilk.gbr cslk.gbr
	mv $(PCBS).front.gbr compont.gbr
	mv $(PCBS).frontmask.gbr cmsk.gbr
	mv $(PCBS).back.gbr solder.gbr
	mv $(PCBS).backmask.gbr smsk.gbr
	mv $(PCBS).plated-drill.cnc drill.cnc
	rm $(PCBS).fab.gbr $(PCBS).frontpaste.gbr 
	zip -jk $(NAME).zip *.gbr drill.cnc ascorder.txt READ.ME
	echo "Do not forget to change the ascorder.txt and READ.ME"

clean:
	rm *.sch~
	rm *.net
	rm *.dat


