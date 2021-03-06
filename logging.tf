/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_logging_metric" "log_alert_metric" {
  for_each = {for item in local.logAlerts: item.name => item}

  name   = each.value.name
  filter = each.value.rule
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

/* TODO: not working anymore
resource "google_logging_project_sink" "logs" {
  depends_on = [google_project_service.compute]

  for_each = {for item in local.loggingSinks: item.name => item}
  name  = each.value.name

  # Can export to pubsub, cloud storage, or bigtable
  destination = "bigquery.googleapis.com/projects/${each.value.name}/datasets/logs"

  # Log all WARN or higher severity messages relating to instances
  filter = "resource.type=container AND resource.jsonPayload.labels.company=${each.value.company}"

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
}
*/
