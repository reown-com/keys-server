# Clickops alert rules codified verbatim from AMG "General Alerting Alerts" folder
# (folder uid eessxa3xe1b0gc). Captured live 2026-07-23 from /api/v1/provisioning/alert-rules
# where provenance=="" (UI-created). Query/model/datasource UID/for/interval/noData/execErr/
# labels/annotations are reproduced EXACTLY, targeting AMG as-is. The __legacy_*__ labels
# preserve the existing OpsGenie routing untouched (re-routing is a migration-phase decision).
#
# THESE RULES ALREADY EXIST IN AMG. Do NOT `terraform apply` before `terraform import`
# (see README_clickops_import.md) or they will be duplicated.

resource "grafana_rule_group" "clickops_keys_prod" {
  folder_uid       = "eessxa3xe1b0gc"
  name             = "Keys-Server - Prod - 1m"
  interval_seconds = 60

  rule {
    name           = "Keys - Prod - ECS - CPU Utilization alert"
    condition      = "A"
    for            = "5m"
    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    is_paused      = false

    annotations = {
      "__alertId__"      = "6"
      "__dashboardUid__" = "keyserver-prod"
      "__panelId__"      = "14"
      "message"          = "Keys - Prod - ECS - CPU utilization is high (over 70%)"
    }
    labels = {
      "__legacy_c_Rust_Team_Grafana__" = "true"
      "__legacy_use_channels__"        = "true"
    }

    data {
      ref_id         = "A"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 0
        to   = 0
      }
      model = jsonencode({
        "conditions" = [
          {
            "evaluator" = {
              "params" = [
                70
              ]
              "type" = "gt"
            }
            "operator" = {
              "type" = "and"
            }
            "query" = {
              "params" = [
                "CPU_Avg"
              ]
            }
            "reducer" = {
              "type" = "avg"
            }
          }
        ]
        "intervalMs"    = 1000
        "maxDataPoints" = 43200
        "refId"         = "A"
        "type"          = "classic_conditions"
      })
    }

    data {
      ref_id         = "CPU_Avg"
      datasource_uid = "70ZP1EmIz"
      relative_time_range {
        from = 300
        to   = 0
      }
      model = jsonencode({
        "alias" = "CPU (Avg)"
        "datasource" = {
          "type" = "cloudwatch"
          "uid"  = "70ZP1EmIz"
        }
        "dimensions" = {
          "ServiceName" = "keyserver-service"
        }
        "expression"       = ""
        "intervalMs"       = 200
        "matchExact"       = false
        "maxDataPoints"    = 1500
        "metricEditorMode" = 0
        "metricName"       = "CPUUtilization"
        "metricQueryType"  = 0
        "namespace"        = "AWS/ECS"
        "period"           = "auto"
        "queryMode"        = "Metrics"
        "refId"            = "CPU_Avg"
        "region"           = "default"
        "statistic"        = "Average"
      })
    }
  }

  rule {
    name           = "Keys - Prod - ECS - Memory Utilization alert"
    condition      = "A"
    for            = "5m"
    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    is_paused      = false

    annotations = {
      "__alertId__"      = "7"
      "__dashboardUid__" = "keyserver-prod"
      "__panelId__"      = "15"
      "message"          = "Keys - Prod - ECS - Memory utilization is high (over 70%)"
    }
    labels = {
      "__legacy_c_Rust_Team_Grafana__" = "true"
      "__legacy_use_channels__"        = "true"
    }

    data {
      ref_id         = "A"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 0
        to   = 0
      }
      model = jsonencode({
        "conditions" = [
          {
            "evaluator" = {
              "params" = [
                70
              ]
              "type" = "gt"
            }
            "operator" = {
              "type" = "and"
            }
            "query" = {
              "params" = [
                "Mem_Avg"
              ]
            }
            "reducer" = {
              "type" = "avg"
            }
          }
        ]
        "intervalMs"    = 1000
        "maxDataPoints" = 43200
        "refId"         = "A"
        "type"          = "classic_conditions"
      })
    }

    data {
      ref_id         = "Mem_Avg"
      datasource_uid = "70ZP1EmIz"
      relative_time_range {
        from = 300
        to   = 0
      }
      model = jsonencode({
        "alias" = "Memory (Avg)"
        "datasource" = {
          "type" = "cloudwatch"
          "uid"  = "70ZP1EmIz"
        }
        "dimensions" = {
          "ServiceName" = "keyserver-service"
        }
        "expression"       = ""
        "intervalMs"       = 200
        "matchExact"       = false
        "maxDataPoints"    = 1500
        "metricEditorMode" = 0
        "metricName"       = "MemoryUtilization"
        "metricQueryType"  = 0
        "namespace"        = "AWS/ECS"
        "period"           = "auto"
        "queryMode"        = "Metrics"
        "refId"            = "Mem_Avg"
        "region"           = "default"
        "statistic"        = "Average"
      })
    }
  }

  rule {
    name           = "Keys - prod DocumentDB CPU alert"
    condition      = "A"
    for            = "5m"
    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    is_paused      = false

    annotations = {
      "__alertId__"      = "8"
      "__dashboardUid__" = "keyserver-prod"
      "__panelId__"      = "23"
      "message"          = "Keys - prod DocumentDB CPU alert"
    }
    labels = {
      "__legacy_c_Rust_Team_Grafana__" = "true"
      "__legacy_use_channels__"        = "true"
    }

    data {
      ref_id         = "A"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 0
        to   = 0
      }
      model = jsonencode({
        "conditions" = [
          {
            "evaluator" = {
              "params" = [
                50
              ]
              "type" = "gt"
            }
            "operator" = {
              "type" = "or"
            }
            "query" = {
              "params" = [
                "CPU_Max"
              ]
            }
            "reducer" = {
              "type" = "avg"
            }
          }
        ]
        "intervalMs"    = 1000
        "maxDataPoints" = 43200
        "refId"         = "A"
        "type"          = "classic_conditions"
      })
    }

    data {
      ref_id         = "CPU_Max"
      datasource_uid = "70ZP1EmIz"
      relative_time_range {
        from = 300
        to   = 0
      }
      model = jsonencode({
        "alias" = "CPU (Max)"
        "datasource" = {
          "type" = "cloudwatch"
          "uid"  = "70ZP1EmIz"
        }
        "dimensions" = {
          "DBClusterIdentifier" = "prod-keyserver-keystore"
        }
        "expression"       = ""
        "intervalMs"       = 200
        "matchExact"       = true
        "maxDataPoints"    = 1500
        "metricEditorMode" = 0
        "metricName"       = "CPUUtilization"
        "metricQueryType"  = 0
        "namespace"        = "AWS/DocDB"
        "period"           = "auto"
        "queryMode"        = "Metrics"
        "refId"            = "CPU_Max"
        "region"           = "default"
        "statistic"        = "Maximum"
      })
    }
  }

  rule {
    name           = "Keys - prod DocumentDB Freeable Memory Alert"
    condition      = "A"
    for            = "5m"
    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    is_paused      = false

    annotations = {
      "__alertId__"      = "9"
      "__dashboardUid__" = "keyserver-prod"
      "__panelId__"      = "24"
      "message"          = "Keys - prod DocumentDB Freeable Memory"
    }
    labels = {
      "__legacy_c_Rust_Team_Grafana__" = "true"
      "__legacy_use_channels__"        = "true"
    }

    data {
      ref_id         = "A"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 0
        to   = 0
      }
      model = jsonencode({
        "conditions" = [
          {
            "evaluator" = {
              "params" = [
                400000000
              ]
              "type" = "lt"
            }
            "operator" = {
              "type" = "and"
            }
            "query" = {
              "params" = [
                "Mem_Avg"
              ]
            }
            "reducer" = {
              "type" = "min"
            }
          }
        ]
        "intervalMs"    = 1000
        "maxDataPoints" = 43200
        "refId"         = "A"
        "type"          = "classic_conditions"
      })
    }

    data {
      ref_id         = "Mem_Avg"
      datasource_uid = "70ZP1EmIz"
      relative_time_range {
        from = 300
        to   = 0
      }
      model = jsonencode({
        "alias" = "Freeable Memory (Avg)"
        "datasource" = {
          "type" = "cloudwatch"
          "uid"  = "70ZP1EmIz"
        }
        "dimensions" = {
          "DBClusterIdentifier" = "prod-keyserver-keystore"
        }
        "expression"       = ""
        "intervalMs"       = 200
        "matchExact"       = true
        "maxDataPoints"    = 1500
        "metricEditorMode" = 0
        "metricName"       = "FreeableMemory"
        "metricQueryType"  = 0
        "namespace"        = "AWS/DocDB"
        "period"           = "auto"
        "queryMode"        = "Metrics"
        "refId"            = "Mem_Avg"
        "region"           = "default"
        "statistic"        = "Average"
      })
    }
  }

  rule {
    name           = "Keys - prod DocumentDB LowMem Num Operations Throttled Alert"
    condition      = "A"
    for            = "5m"
    no_data_state  = "Alerting"
    exec_err_state = "Alerting"
    is_paused      = false

    annotations = {
      "__alertId__"      = "10"
      "__dashboardUid__" = "keyserver-prod"
      "__panelId__"      = "26"
      "message"          = "Keys - prod DocumentDB LowMem Num Operations Throttled"
    }
    labels = {
      "__legacy_c_Rust_Team_Grafana__" = "true"
      "__legacy_use_channels__"        = "true"
    }

    data {
      ref_id         = "A"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 0
        to   = 0
      }
      model = jsonencode({
        "conditions" = [
          {
            "evaluator" = {
              "params" = [
                2
              ]
              "type" = "gt"
            }
            "operator" = {
              "type" = "and"
            }
            "query" = {
              "params" = [
                "Ops_Max"
              ]
            }
            "reducer" = {
              "type" = "max"
            }
          }
        ]
        "intervalMs"    = 1000
        "maxDataPoints" = 43200
        "refId"         = "A"
        "type"          = "classic_conditions"
      })
    }

    data {
      ref_id         = "Ops_Max"
      datasource_uid = "70ZP1EmIz"
      relative_time_range {
        from = 300
        to   = 0
      }
      model = jsonencode({
        "alias" = "LowMem Num Operations Throttled (Max)"
        "datasource" = {
          "type" = "cloudwatch"
          "uid"  = "70ZP1EmIz"
        }
        "dimensions" = {
          "DBClusterIdentifier" = "prod-keyserver-keystore"
        }
        "expression"       = ""
        "intervalMs"       = 200
        "matchExact"       = true
        "maxDataPoints"    = 1500
        "metricEditorMode" = 0
        "metricName"       = "LowMemNumOperationsThrottled"
        "metricQueryType"  = 0
        "namespace"        = "AWS/DocDB"
        "period"           = "auto"
        "queryMode"        = "Metrics"
        "refId"            = "Ops_Max"
        "region"           = "default"
        "statistic"        = "Maximum"
      })
    }
  }

  rule {
    name           = "Keys - Prod - 5XX alert"
    condition      = "A"
    for            = "0s"
    no_data_state  = "NoData"
    exec_err_state = "Alerting"
    is_paused      = false

    annotations = {
      "__alertId__"      = "58"
      "__dashboardUid__" = "keyserver-prod"
      "__panelId__"      = "21"
      "message"          = "Keys - Prod - Notify - 5XX alert"
    }
    labels = {
      "__legacy_c_Rust_Team_Grafana__" = "true"
      "__legacy_use_channels__"        = "true"
    }

    data {
      ref_id         = "A"
      datasource_uid = "__expr__"
      relative_time_range {
        from = 0
        to   = 0
      }
      model = jsonencode({
        "conditions" = [
          {
            "evaluator" = {
              "params" = [
                5
              ]
              "type" = "gt"
            }
            "operator" = {
              "type" = "or"
            }
            "query" = {
              "params" = [
                "ELB"
              ]
            }
            "reducer" = {
              "type" = "avg"
            }
          },
          {
            "evaluator" = {
              "params" = [
                5
              ]
              "type" = "gt"
            }
            "operator" = {
              "type" = "or"
            }
            "query" = {
              "params" = [
                "Target"
              ]
            }
            "reducer" = {
              "type" = "avg"
            }
          }
        ]
        "intervalMs"    = 1000
        "maxDataPoints" = 43200
        "refId"         = "A"
        "type"          = "classic_conditions"
      })
    }

    data {
      ref_id         = "ELB"
      datasource_uid = "70ZP1EmIz"
      relative_time_range {
        from = 300
        to   = 0
      }
      model = jsonencode({
        "alias" = "ELB"
        "datasource" = {
          "type" = "cloudwatch"
          "uid"  = "70ZP1EmIz"
        }
        "dimensions" = {
          "LoadBalancer" = "app/prod-keyserver-oriented-lynx/164e21b900d4c5d7"
        }
        "expression"       = ""
        "intervalMs"       = 200
        "matchExact"       = false
        "maxDataPoints"    = 1500
        "metricEditorMode" = 0
        "metricName"       = "HTTPCode_ELB_5XX_Count"
        "metricQueryType"  = 0
        "namespace"        = "AWS/ApplicationELB"
        "period"           = "auto"
        "queryMode"        = "Metrics"
        "refId"            = "ELB"
        "region"           = "default"
        "statistic"        = "Sum"
      })
    }

    data {
      ref_id         = "Target"
      datasource_uid = "70ZP1EmIz"
      relative_time_range {
        from = 300
        to   = 0
      }
      model = jsonencode({
        "alias" = "Target"
        "datasource" = {
          "type" = "cloudwatch"
          "uid"  = "70ZP1EmIz"
        }
        "dimensions" = {
          "LoadBalancer" = "app/prod-keyserver-oriented-lynx/164e21b900d4c5d7"
        }
        "expression"       = ""
        "intervalMs"       = 200
        "matchExact"       = false
        "maxDataPoints"    = 1500
        "metricEditorMode" = 0
        "metricName"       = "HTTPCode_Target_5XX_Count"
        "metricQueryType"  = 0
        "namespace"        = "AWS/ApplicationELB"
        "period"           = "auto"
        "queryMode"        = "Metrics"
        "refId"            = "Target"
        "region"           = "default"
        "statistic"        = "Sum"
      })
    }
  }

}
