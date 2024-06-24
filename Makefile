BASEPATH=$(PWD)
EXEC=server.jar
MAXMEM=6144
BACKUPNAME="world-$(shell date '+%F-%H%M').tar.gz"
BAKPATH=$(BASEPATH)/backup
JAVAFLAGS=" -Xms6144M \
     -Xmx$(MAXMEM)M \
     -XX:+AlwaysPreTouch \
     -XX:+DisableExplicitGC \
     -XX:+ParallelRefProcEnabled \
     -XX:+PerfDisableSharedMem \
     -XX:+UnlockExperimentalVMOptions \
     -XX:+UseG1GC \
     -XX:G1HeapRegionSize=8M \
     -XX:G1HeapWastePercent=5 \
     -XX:G1MaxNewSizePercent=40 \
     -XX:G1MixedGCCountTarget=4 \
     -XX:G1MixedGCLiveThresholdPercent=90 \
     -XX:G1NewSizePercent=30 \
     -XX:G1RSetUpdatingPauseTimePercent=5 \
     -XX:G1ReservePercent=20 \
     -XX:InitiatingHeapOccupancyPercent=15 \
     -XX:MaxGCPauseMillis=200 \
     -XX:MaxTenuringThreshold=1 \
     -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar $(EXEC) nogui

# MAKEFLAGS += --silent

all: help

## require: install required programs
.PHONY: require
require: path-require
	sudo apt update
	sudo apt -y install tmux openjdk-21-jre

.PHONY: path-require
path-require:
	mkdir -p $(BAKPATH)

## start: start minecraft server in screen session
.PHONY: start
start:
	java $(JAVAFLAGS)

.PHONY: start-debug
start:
	tmux new-session -d -s $(TMUXNAME) 'java $(JAVAFLAGS)'\

## console: control mc server in console
.PHONY: console
console:
	tmux new-session -A -s $(TMUXNAME)

## stop: stop mc server in screen session
.PHONY: stop
stop:
	tmux send-keys -t $(TMUXNAME) "quit" ENTER

## backup: tar world dir for backup
.PHONY: backup
backup:
	@tar czvf $(BACKUPNAME) $(WORLDNAME)
	@mv $(BACKUPNAME) $(BAKPATH)/.

## help: show this menu
.PHONY: help
help: Makefile
	@echo
	@echo " Choose a command run: "
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' | sed -e 's/^/ /'
	@echo
