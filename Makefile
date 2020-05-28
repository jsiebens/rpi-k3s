define build_image
	rm ${PWD}/dist/$1.img || true
	rm -rf ${PWD}/output-arm-image
	docker run \
		--rm \
		--privileged \
		-v ${PWD}:/build:ro \
		-v ${PWD}/packer_cache:/build/packer_cache \
		-v ${PWD}/output-arm-image:/build/output-arm-image \
		quay.io/solo-io/packer-builder-arm-image:v0.1.4.5 build -var-file=/build/packer/variables.json "/build/packer/$1.json"
	mkdir -p ${PWD}/dist
	mv ${PWD}/output-arm-image/image ${PWD}/dist/$1.img
	rm -rf ${PWD}/output-arm-image
endef

.PHONY = %

all: k3s-agent.img k3s-server.img

dist: k3s-agent.tgz k3s-server.tgz

clean:
	rm -rf dist

%.img:
	$(call build_image,$*)

%.tgz: %.img
	rm -rf dist/$@
	tar -czvf dist/$@ -C dist $<