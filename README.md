# fluxcon-d2-infra

Platform-team repository for the FluxCon 2026 demo *"Your VMs Are Just CRDs"*.
It is the D2 **infra** analogue: it owns the KubeSwift platform install and the
shared VM building blocks (guest class, golden images, seed profile).

Nothing in a cluster pulls this repository. CI publishes each component as a
signed OCI artifact and Flux consumes the artifact.

| Component | Path | OCI artifact |
|---|---|---|
| KubeSwift platform (chart OCIRepository + HelmRelease) | `components/kubeswift-platform` | `ghcr.io/wrkode/fluxcon-d2-infra/kubeswift-platform` |
| VM building blocks (SwiftGuestClass, SwiftImage x2, SwiftSeedProfile) | `components/kubeswift-infra` | `ghcr.io/wrkode/fluxcon-d2-infra/kubeswift-infra` |
| Golden VM disks web-v1 / web-v2 (VM-disk artifacts, not config) | `golden-images/` | `ghcr.io/wrkode/fluxcon-d2-infra/vm-images` |

Based on the Flux D2 reference architecture by ControlPlane
([d2-infra](https://github.com/controlplaneio-fluxcd/d2-infra), Apache-2.0),
reduced to a single cluster.
