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

# TODO: Create notification channels here.
# Getting auth token for slack is not so easy?
# https://stackoverflow.com/questions/54884815/obtain-slack-auth-token-for-terraform-google-monitoring-notification-channel-res

# TODO: Create StackDriver workspace once implemented:
# https://github.com/hashicorp/terraform-provider-google/issues/2605#issuecomment-609924289

data "google_monitoring_notification_channel" "alert_channel" {
  for_each     = {for item in local.alertChannelNames: item => item}
  display_name = each.value
}

resource "google_monitoring_alert_policy" "log_alert_policy" {
  depends_on = [
    google_logging_metric.log_alert_metric,
  ]
  for_each = {for item in local.logAlerts: item.name => item}

  display_name          = each.value.name
  enabled               = true
  notification_channels = [
    for i in each.value.channelIndices:
    data.google_monitoring_notification_channel.alert_channel[i].name
  ]

  combiner     = "OR"
  conditions {
    display_name = each.value.name
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/${each.value.name}\" AND resource.type=\"k8s_container\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}
