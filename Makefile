.PHONY = %

SRCS := $(wildcard packer/rpi-*.json)
IMAGES := $(SRCS:packer/rpi-%.json=rpi-%.img)

all: ${IMAGES}

clean:
	rm -rf images
	rm -rf dist

%.img:
	sudo packer build -var-file=packer/variables.json "packer/$*.json"
