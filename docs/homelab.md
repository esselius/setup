```mermaid
mindmap
    root((Home Lab))
        Monitoring
            Grafana
                Metrics
                    Prometheus
                Logs
                    Loki
                        Promtail
        Home Assistant
            Automation
                Node-RED    
            Zigbee
                Zigbee2MQTT
                    MQTT Broker
                        Mosquitto
            Voice Assistant
                Piper
                Whisper
                Ollama
        Access
            Encryption
              Internal mTLS
              External TLS
            Static IP
            Auth
              Authentik
                OIDC Provider
                Radius Provider
        Network
            OpenWRT
                Apollo
                    Router
                    AP
                Gaeta
                    AP
        Hardware
            Servers
                Raspberry Pi 5
                    Adama: 4GB + 64GB
                    Starbuck: 8GB + 256GB
```

## Workload Management

Meta goals
- Fun to build & use
- Easy maintainance
- Swiftly getting core services back up when hw fails
- Services backed up before upgrades
- Possible to roll back breaking upgrade with restored data
- 

Design goals
- Single deploy flow
- Minimal change disruption
- Reasonable system overhead vs workload ratio
- Backup
  - Local & remote
  - Restore proceedure
- Stable & common solutions
- Low complexity networking
- Explicit resource allocation
- Telemetry
  - Metrics
  - Logging
  - Alerting
- 

```mermaid
mindmap
  root((Making changes))
    Thin VM host
      Complexity
        Low host os change rate
        Minimal host os services
        Medium abstraction layer stack
        Backup: VMs
      Cons
        VM overhead
          Causes service grouping
      Pros
        Supports specialized workload OS
    Thin plain container host
      Complexity
        Minor host os change rate
        Minimal host os services
        Minor abstraction layer stack
        Backup: Container volumes
      Pros
        Low overhead
      Cons
        Requires containerized workloads
    Thin k8s host
      Complexity
        Low host os change rate
        Thick abstraction layer stack
        Backup: K8s volumes & state
      Cons
        High base overhead when done proper
          Causes mixed model
        Requires containerized workloads
        High API change rate
    Plain service host
      Complexity
        High host os change rate
        Workloads run as host os services
        Minor abstraction layer stack
        Backup: Service data
      Pros
        No overhead
      Cons
        No isolation
    
```

```mermaid
flowchart LR
  HOST["Host OS"]
  LIBVIRT
  QEMU
  VM["VM: Full System"]
  PODMAN
  LXD
  LXC
  VEP["VE: Single Process"]
  VES["VE: Full System"]

  HOST --> LIBVIRT --> QEMU --> VM
  HOST --> PODMAN --> VEP
  HOST --> LXD--> LXC --> VES
  LIBVIRT --> LXC
```

```mermaid
erDiagram
  H["HOST"]
  VM["VIRTUAL MACHINE"] {
    type qemu
  }
  LXC["CONTAINER"] {
    type LXC
  }
  LXCC["CONTAINER"] {
    type podman
  }
  C["CONTAINER"] {
    type podman
  }
  NC["CONTAINER"] {
    type nixosContainer
  }
  VMLXC["CONTAINER"] {
    type LXC
  }
  VMLXCC["CONTAINER"] {
    type podman
  }
  VMC["CONTAINER"] {
    type podman
  }
  SU["SYSTEM SERVICE"] {
    type systemd
  }
  VMSU["SYSTEM SERVICE"] {
    type systemd
  }

  H ||--o{ VM: ""
  H ||--o{ C: ""
  H ||--|{ SU: ""
  H ||--|{ LXC: ""
  H ||--|{ NC: ""

  LXC }|--|{ LXCC: ""

  VM |o--o{ VMC: ""
  VM }o--o{ VMLXC: ""
  VM }|--|{ VMSU: ""
  
  VMLXC }|--|{ VMLXCC: ""

```

## Workloads

```mermaid
flowchart TD
  LV1["Libvirt"]
  LV2["Libvirt"]
  Z2M["Zigbee2MQTT"]
  HA["Home Assistant"]
  MQTT["Mosquitto"]
  P["Prometheus"]
  G["Grafana"]
  PT["Promtail"]
  L["Loki"]
  AUTH["Authentik"]
  N["Nginx"]

  subgraph A["Adama"]
    Z2M
    HA
    MQTT
    LV1
  end

  subgraph S["Starbuck"]
    P
    G
    PT
    L
    AUTH
    N
    LV2
  end

  Z2M <--> MQTT
  HA <--> MQTT
```
