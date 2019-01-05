# Homework
## Public machinery for homework (split out of Tests, uses info in assign)

######################################################################

## Hooks

current: target
target = Makefile
-include target.mk

###################################################################

# stuff

Sources += Makefile README.md LICENSE.md

ms = makestuff
Sources += $(ms)
Makefile: $(ms)/Makefile

$(ms)/%.mk: $(ms)/Makefile ;
$(ms)/Makefile:
	git submodule update -i

-include $(ms)/os.mk

-include $(ms)/perl.def
## -include $(ms)/repos.def

######################################################################

## Directories

## Life_tables dropped 2018 Nov 27 (Tue)

## A private directory with assignment and test content
dirs += assign
assign:
	git submodule add -b master https://github.com/Bio3SS/Assignments $@

pushdir = ../web/materials

repodirs += assign

Sources += $(mdirs) $(repodirs)

######################################################################

## Content

## Assignments

Sources += $(wildcard *.asn)
Ignore += *.asn.* *.key.* *.rub.*

## Intro (NFC)
intro.asn.pdf: assign/intro.ques
intro.key.pdf: assign/intro.ques

## Population growth
## For-credit 2018
pg.asn.pdf: assign/pg.ques
pg.key.pdf: assign/pg.ques
pg.rub.pdf: assign/pg.ques

## Intro R (NFC, lives on wiki)

## For-credit 2018
## Regulation (uses some R, lives here, points to wiki)
regulation.asn.pdf: assign/regulation.ques
regulation.key.pdf: assign/regulation.ques
regulation.rub.pdf: assign/regulation.ques

## An allee question that has fallen between the cracks. Could be added to the previous or following assignment
## Previous assignment currently has a detailed Allee question, though.
allee.asn.pdf: assign/allee.ques

## Structure assignment
## For-credit 2018
structure.asn.pdf: assign/structure.ques
structure.key.pdf: assign/structure.ques
structure.rub.pdf: assign/structure.ques

######################################################################

## Not yet made here

## Interaction is an old assignment, now broken up into a very short (life history) assignment and a slightly longer (competition) assignment
## Now just misnamed life history (NFC 2018)
interaction.asn.pdf: assign/interaction.ques
interaction.key.pdf: assign/interaction.ques

## For-credit 2018
competition.asn.pdf: assign/competition.ques
competition.key.pdf: assign/competition.ques
competition.rub.pdf: assign/competition.ques

expl.asn.pdf: assign/expl.ques

######################################################################

## lect and talk resources

Ignore += lect
lect/%: 
	$(MAKE) lect

lect: dir=makestuff
lect:
	$(linkdir)

Ignore += talk
.PRECIOUS: talk/%
talk/%: 
	$(MAKE) talk

talk: dir=makestuff/newtalk
talk:
	$(linkdirname)

######################################################################

## knitr 

## Pre-knit markup
Ignore += *.ques
%.ques: assign/%.ques lect/knit.fmt talk/lect.pl
	$(PUSH)

## Knit
Ignore += *.qq
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

