conditions {
  display_name = "Service Health incident (new confirmed; related/impacted)"
  condition_matched_log {
    filter = "resource.type = \"servicehealth.googleapis.com/Event\" AND labels.\"servicehealth.googleapis.com/new_event\"=true AND jsonPayload.category=\"INCIDENT\" AND (jsonPayload.relevance=\"RELATED\" OR jsonPayload.relevance=\"IMPACTED\") AND jsonPayload.@type=\"type.googleapis.com/google.cloud.servicehealth.logging.v1.EventLog\" AND jsonPayload.detailedState=\"CONFIRMED\""

    # Optional: extract fields from the log for use in notification templates.
    label_extractors = {
      state             = "EXTRACT(jsonPayload.state)"
      description       = "EXTRACT(jsonPayload.description)"
      impactedProducts  = "EXTRACT(jsonPayload.impactedProducts)"
      impactedLocations = "EXTRACT(jsonPayload.impactedLocations)"
      startTime         = "EXTRACT(jsonPayload.startTime)"
      title             = "EXTRACT(jsonPayload.title)"
    }
  }
}
