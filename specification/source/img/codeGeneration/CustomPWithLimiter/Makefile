modelicajson = ~/proj/ldrd/bie/modeling/github/lbl-srg/modelica-json

diagnostics:
	@echo "MODELICAPATH is $(MODELICAPATH)"

all: export-json-simplified export-json export-html

export-json-simplified:
	node $(modelicajson)/app.js -f CustomPWithLimiter.mo -o json-simplified

export-json:
	node $(modelicajson)/app.js -f CustomPWithLimiter.mo -o json

export-html:
	node $(modelicajson)/app.js -f CustomPWithLimiter.mo -o html
