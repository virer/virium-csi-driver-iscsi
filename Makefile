FILE=VERSION
TAG=`cat $(FILE)`

clean:
	rm -f bin/virium-iscsiplugin

mod-check:
	go mod verify && [ "$(shell sha512sum go.mod)" = "`sha512sum go.mod`" ] || ( echo "ERROR: go.mod was modified by 'go mod verify'" && false )

newversion:
	echo ${TAG}

all:
	./scripts/newversion.sh
	rm -f bin/virium-iscsiplugin
	cd cmd/virium-iscsiplugin; CGO_ENABLED=0 GOOS=linux go build -o ../../bin/virium-iscsiplugin 
	cd cmd/virium-controller; CGO_ENABLED=0 GOOS=linux go build -o ../../bin/virium-controller
	podman build -t docker.io/scaps/virium-csi-driver-iscsi:${TAG} . && podman push --authfile=${HOME}/.docker/dockerconfig docker.io/scaps/virium-csi-driver-iscsi:${TAG}
	podman -f Dockerfile-controller build -t docker.io/scaps/virium-controller:${TAG} . && podman push --authfile=${HOME}/.docker/dockerconfig docker.io/scaps/virium-controller:${TAG}
