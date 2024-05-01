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

### Base needs

- Status dashboard
- Revertable changes
- Plan for failure
- Safe tinkering

### Design goals

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

```mermaid
mindmap
  root((Making changes))
    Thin VM host
      Complexity
        Backup: VMs
      Cons
        VM overhead
          Causes service grouping
        Medium abstraction layer stack
      Pros
        Minimal host os services
        Low host os change rate
        Supports specialized workload OS
    Thin plain container host
      Complexity
        Backup: Container volumes
      Pros
        Minor host os change rate
        Minimal host os services
        Minor abstraction layer stack
        Low overhead
      Cons
        Requires containerized workloads
    Thin k8s host
      Complexity
        Backup: K8s volumes & state
      Cons
        High base overhead when done proper
          Causes mixed model
        Requires containerized workloads
        High API change rate
        Thick abstraction layer stack
      Pros
        Low host os change rate
    Plain service host
      Complexity
        Workloads run as host os services
        Backup: Service data
      Pros
        Minor abstraction layer stack
        No overhead
      Cons
        High host os change rate
        No isolation
    
```

### Resource management

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
