# Clickops alert import — Keys-Server - Prod - 1m

These 6 alert rules were created via the AMG UI (clickops, `provenance=""`) and are
now codified in `alerts.tf` **exactly as they exist in AMG** (folder `eessxa3xe1b0gc` =
"General Alerting Alerts"). They already exist in the live AMG workspace `g-aa89c04cfd`.

## Do NOT apply before importing
`grafana_rule_group` is a whole-group resource. Because these rules already exist in AMG,
a naive `terraform apply` would create duplicates. Import the existing group into state first,
then `terraform plan` should show **no changes** (proving fidelity).

```sh
# import id format: <folderUID>:<groupName>  (verify against the pinned grafana provider version)
terraform import 'module.monitoring.grafana_rule_group.clickops_keys_prod' 'eessxa3xe1b0gc:Keys-Server - Prod - 1m'
```

## Rules in this group (title → existing AMG rule UID)
| # | Title | AMG rule UID | Legacy contact (label) |
|--:|-------|--------------|------------------------|
| 1 | Keys - Prod - ECS - CPU Utilization alert | `cessxa3td76yoe` | Rust_Team_Grafana |
| 2 | Keys - Prod - ECS - Memory Utilization alert | `eessxa3tapam8b` | Rust_Team_Grafana |
| 3 | Keys - prod DocumentDB CPU alert | `fessxa3td76yqf` | Rust_Team_Grafana |
| 4 | Keys - prod DocumentDB Freeable Memory Alert | `eessxa3tapam9a` | Rust_Team_Grafana |
| 5 | Keys - prod DocumentDB LowMem Num Operations Throttled Alert | `aessxa3tapamae` | Rust_Team_Grafana |
| 6 | Keys - Prod - 5XX alert | `bessxa3td76ypc` | Rust_Team_Grafana |

> Rule UIDs are recorded for reference; the group itself imports by `<folderUID>:<groupName>`.
> Re-routing these OpsGenie legacy channels to incident.io is a migration-phase decision.
