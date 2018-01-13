# Homework

######################################################################

## Hooks

current: target
target = Makefile
-include target.mk

###################################################################

# stuff

Sources += Makefile .ignore README.md substuff.mk LICENSE.md

## Change Drop with untracked local.mk (called automatically from substuff.mk)
Drop = ~/Dropbox

-include substuff.mk
# -include $(ms)/perl.def
# -include $(ms)/newtalk.def
# -include $(ms)/repos.def

######################################################################

## Directories

# clonedirs += clone
clone:
	git clone https://github.com/Bio3SS/$@.git

## A private directory with assignment and test content
specdirs += assign
assign:
	git submodule add -b master https://github.com/Bio3SS/Assignments $@

# pushdir = web/materials

## repodirs have auto-making rules from modules.mk
## mdirs are used by recursive git rules
repodirs += $(specdirs)
mdirs = $(specdirs)

######################################################################

## Content

## Assignments

Sources += $(wildcard *.asn)

## Intro (NFC)
intro.asn.pdf: assign/intro.ques

intro.asn.tex:

## 

## Population growth
pg.asn.pdf: assign/pg.ques

## Intro R (NFC, lives on wiki)

## Regulation (uses some R, lives here, points to wiki)
regulation.asn.pdf: assign/regulation.ques
regulation.key.pdf: assign/regulation.ques
regulation.rub.pdf: assign/regulation.ques

## An allee question that has fallen between the cracks. Could be added to the previous or following assignment
## Previous assignment currently has a detailed Allee question, though.
allee.asn.pdf: assign/allee.ques

## Structure assignment
## Often given for credit
structure.asn.pdf: assign/structure.ques
structure.key.pdf: assign/structure.ques
structure.rub.pdf: assign/structure.ques

## Interaction is an old assignment, now broken up into a very short (life history) assignment and a slightly longer (competition) assignment
interaction.asn.pdf: assign/interaction.ques

competition.asn.pdf: assign/competition.ques
competition.key.pdf: assign/competition.ques

expl.asn.pdf: assign/expl.ques

######################################################################

## lect directory

Ignore += lect/

lect/%: 
	$(MAKE) lect

lect: dir=makestuff
lect:
	$(linkdir)

######################################################################

## knitr 

## Pre-knit markup
%.ques: assign/%.ques lect/knit.fmt talk/lect.pl
	$(PUSH)

## Knit
knit = echo 'knitr::knit("$<", "$@")' | R --vanilla
%.qq: %.ques
	$(knit)

######################################################################

## Markup for different products
Sources += asn.tmp copy.tex

%.ques.fmt: lect/ques.format lect/fmt.pl
	$(PUSHSTAR)

%.asn.tex: %.qq asn.tmp asn.ques.fmt talk/lect.pl
	$(PUSH)

%.old.asn.tex: assign/%.ques asn.tmp asn.ques.fmt talk/lect.pl
	$(PUSH)

%.key.tex: %.qq asn.tmp key.ques.fmt talk/lect.pl
	$(PUSH)

%.rub.tex: %.qq asn.tmp rub.ques.fmt talk/lect.pl
	$(PUSH)

##################################################################

-include $(ms)/visual.mk
-include $(ms)/git.mk
-include $(ms)/texdeps.mk

# -include $(ms)/newtalk.mk

-include $(ms)/modules.mk

# -include $(ms)/webpix.mk
# -include $(ms)/wrapR.mk

