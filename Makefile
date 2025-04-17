TAG=v0.1.8

clean:
	rm -f bin/virium-iscsiplugin

mod-check:
	go mod verify && [ "$(shell sha512sum go.mod)" = "`sha512sum go.mod`" ] || ( echo "ERROR: go.mod was modified by 'go mod verify'" && false )

newversion:
	./scripts/newversion.sh

all:
	rm -f bin/virium-iscsiplugin
	cd cmd/virium-iscsiplugin; CGO_ENABLED=0 GOOS=linux go build -o ../../bin/virium-iscsiplugin 
	podman build -t docker.io/scaps/virium-csi-driver-iscsi:${TAG} . && podman push --authfile=${HOME}/.docker/dockerconfig docker.io/scaps/virium-csi-driver-iscsi:${TAG}
