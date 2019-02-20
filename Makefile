# Homework
## Public machinery for homework (split out of Tests, uses info in material)

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

## Intro R (NFC, moving from wiki)

## /bin/cp -rf r.md r_files ../web/materials

######################################################################

## rmd pipelining (much to be done!)

rmd = $(wildcard *.rmd)
Ignore += %.yaml.md *.rmd.md %.export.md
Sources += $(rmd)

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
# bd.export.gh.html: bd.rmd
# r.export.gh.html: 

######################################################################

### ADD point outline to future HWs!

## For-credit 2018
## Regulation (uses some R, lives here, points to wiki)
regulation.asn.pdf: material/regulation.ques
regulation.key.pdf: material/regulation.ques
regulation.rub.pdf: material/regulation.ques

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

-include $(ms)/modules.mk

# -include $(ms)/webpix.mk
# -include $(ms)/wrapR.mk

