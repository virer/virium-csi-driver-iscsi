# Virim iSCSI CSI Driver for Kubernetes

## 🚀 Overview

This repository contains the **Virim CSI driver** — a Kubernetes CSI-compatible plugin that extends the functionality of the [official iSCSI CSI driver](https://github.com/kubernetes-csi/csi-driver-iscsi) to support **dynamic provisioning**.

**CSI plugin name**: `virium.csi.virer.net`

This driver works in conjunction with a running and properly configured [**Viriumd** API server](https://github.com/virer/viriumd), which handles the underlying LVM and iSCSI operations.

---

## 🔧 Features

- Dynamic volume provisioning and deletion
- Multi-node support
- Attach, mount, detach, unmount workflows via CSI
- Kubernetes native PersistentVolume (PV) lifecycle integration

### ⚙️ Planned Features

- Volume resizing support
- Snapshot creation
- Volume cloning

---

## ⚠️ Requirements

- A running instance of **Viriumd**, configured and reachable by the driver
- iSCSI initiator configured on all cluster nodes
- Kubernetes v1.20+ (CSI-compatible)

---

## 🧪 Project Status

**Status:** `Beta`

- ✅ Volume creation and deletion are functional on multi-node Kubernetes clusters
- 🚧 Feature expansion (resizing, snapshots, cloning) in active development

---

## 📚 References

- [Viriumd API server](https://github.com/virer/viriumd)
- [Kubernetes CSI Documentation](https://kubernetes-csi.github.io/docs/)
- [csi-driver-iscsi (upstream)](https://github.com/kubernetes-csi/csi-driver-iscsi)

---

## 🤝 Contributions

This project is open for testing, feedback, and contributions

## Installation:

For installation please use helm charts

Create a values.yaml 
```
virium:
  virium:
    image:
      repository: docker.io/scaps/virium-csi-driver-iscsi
      tag: v0.2.3.4
  nodeSelector:
    kubernetes.io/os: linux
viriumConfig:
  apiUsername: "virium_api_username"
  apiPassword: "virium_api_password"
  apiurl: "http://192.168.0.147:8787"
  initiator: "iqn.2025-04.net.virer.virium:target1"
  debug: "2"
```

Then configure the helm repository and deploy the charts
```
helm repo add virium https://virer.github.io/virium-helm-repo/charts/
helm repo update
helm search repo virium
helm install a1 virium --namespace=virium --create-namespace -f values.yaml 
```

Then use the following storageClass:

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: virium
provisioner: virium.csi.virer.net
allowVolumeExpansion: true
```

And use the following as snapshotClass:
```
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: csi-virium-snapclass
driver: virium.csi.virer.net
deletionPolicy: Delete
```