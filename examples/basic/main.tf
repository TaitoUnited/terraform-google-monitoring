module "monitoring" {
  source  = "dexcom/monitoring/google"
  version = "2.0.0"

  alerts = yamldecode(file("./alerts.yaml"))["alerts"]
}