define build_image
	rm ${PWD}/dist/rpi-$1.iso || true
	rm -rf ${PWD}/output-arm-image
	docker run \
		--rm \
		--privileged \
		-v ${PWD}:/build:ro \
		-v ${PWD}/packer_cache:/build/packer_cache \
		-v ${PWD}/output-arm-image:/build/output-arm-image \
		quay.io/solo-io/packer-builder-arm-image:v0.1.4.5 build -var-file=/build/packer/variables.json "/build/packer/$1.json"
	mkdir -p ${PWD}/dist
	mv ${PWD}/output-arm-image/image ${PWD}/dist/rpi-$1.iso
	rm -rf ${PWD}/output-arm-image
endef

.PHONY: all
all: k3s-server k3s-agent

.PHONY: k3s-server
k3s-server:
	$(call build_image,k3s-server)

.PHONY: k3s-agent
k3s-agent:
	$(call build_image,k3s-agent)