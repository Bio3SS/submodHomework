# Homework
## Public machinery for homework (split out of Tests, uses info in material)

## 2019 Mar 10 (Sun) DEPRECATE all working subdirectories; use source!
## If kids can do it, we can do it
## Also: working on stepR local pipelines

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
mdirs += material
material:
	git submodule add -b master https://github.com/Bio3SS/Evaluation_materials $@

pushdir = ../web/materials

hotdirs += materials

######################################################################

## Content

## Assignments

Sources += $(wildcard *.asn)
Ignore += *.asn.* *.key.* *.rub.*

## Intro (NFC)
intro.asn.pdf: material/intro.ques
intro.key.pdf: material/intro.ques

## Population growth
## For-credit 2018, 2019
pg.asn.pdf: material/pg.ques
pg.key.pdf: material/pg.ques
pg.rub.pdf: material/pg.ques

######################################################################

## Intro R (NFC, moved from wiki)
## This doesn't link perfectly here. shiprmd to send it to it's native home
# r.export.gh.html: r.rmd
# bd.export.gh.html: bd.rmd

######################################################################

### ADD point outline to future HWs!

## For-credit 2018
## Regulation (uses some R, lives here, points to wiki)
regulation.asn.pdf: material/regulation.ques
regulation.key.pdf: material/regulation.ques
regulation.rub.pdf: material/regulation.ques

## Pipelining with .R files
## 2019 Mar 10 (Sun)
regulation.qq: material/regulation.RData
regulation.Rout: material/regulation.R
	$(run-R)

Ignore += bd.R
material/regulation.R: bd.R ;
bd.R:
	wget -O $@ "https://raw.githubusercontent.com/Bio3SS/Exponential_figures/master/bd.R" 

## Definitely want to be working on stepR pipelining!
regulation.key.pdf regulation.rub.pdf: regulation.Rout-0.pdf regulation.Rout-1.pdf regulation.Rout-2.pdf regulation.Rout-3.pdf regulation.Rout-4.pdf



## An allee question that has fallen between the cracks. Could be added to the previous or following assignment
## Previous assignment currently has a detailed Allee question, though.
allee.asn.pdf: material/allee.ques

## Structure assignment
## For-credit 2018
structure.asn.pdf: material/structure.ques
structure.key.pdf: material/structure.ques
structure.rub.pdf: material/structure.ques

######################################################################

## Not yet made here

## Interaction is an old assignment, now broken up into a very short (life history) assignment and a slightly longer (competition) assignment
## Now just misnamed life history (NFC 2018)
interaction.asn.pdf: material/interaction.ques
interaction.key.pdf: material/interaction.ques

## For-credit 2018
competition.asn.pdf: material/competition.ques
competition.key.pdf: material/competition.ques
competition.rub.pdf: material/competition.ques

expl.asn.pdf: material/expl.ques

######################################################################

## lect and talk resources

Ignore += lect
.PRECIOUS: lect/%
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

## rmd pipelining (much to be done!)

rmd = $(wildcard *.rmd)
Ignore += *.yaml.md *.rmd.md *.export.md
Sources += $(rmd)
Ignore += *.export.* *_files/

## Direct translation
%.rmd.md: %.rmd
	Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$@")'

## Add headers
%.yaml.md: %.rmd Makefile
	perl -nE "last if /^$$/; print; END{say}" $< > $@

%.export.md: %.yaml.md %.rmd.md
	$(cat)

%.rmdout: %.export.md
	- $(RMR) $(pushdir)/$*.rmd_files
	$(CP) -r $< $(pushdir)
	- $(CP) -r $< $*.rmd_files $(pushdir)

shiprmd = $(rmd:rmd=rmdout)
shiprmd: $(shiprmd)
## bd.rmdout: bd.rmd

######################################################################
## knitr 

## Pre-knit markup
Ignore += *.ques
%.ques: material/%.ques lect/knit.fmt talk/lect.pl
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

%.key.tex: %.qq asn.tmp key.ques.fmt talk/lect.pl
	$(PUSH)

%.rub.tex: %.qq asn.tmp rub.ques.fmt talk/lect.pl
	$(PUSH)

##################################################################

-include $(ms)/visual.mk
-include $(ms)/git.mk
-include $(ms)/texdeps.mk
-include $(ms)/pandoc.mk

# -include $(ms)/newtalk.mk

-include $(ms)/hotcold.mk

# -include $(ms)/webpix.mk

## Using wrap because step doesn't (yet) understanding hiding ☹
-include $(ms)/wrapR.mk
