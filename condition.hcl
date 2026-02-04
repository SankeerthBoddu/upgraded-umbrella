locals {
  conditions = {
    condition_1 = {
      display_name = "PSH incident (new confirmed; related/impacted)"

      condition_matched_log = {
        filter = "resource.type=\"servicehealth.googleapis.com/Event\" AND labels.\"servicehealth.googleapis.com/new_event\"=true AND jsonPayload.category=\"INCIDENT\" AND (jsonPayload.relevance=\"RELATED\" OR jsonPayload.relevance=\"IMPACTED\") AND jsonPayload.@type=\"type.googleapis.com/google.cloud.servicehealth.logging.v1.EventLog\" AND jsonPayload.detailedState=\"CONFIRMED\""

        # Optional: only include if your module supports passing this through.
        # label_extractors = {
        #   title       = "EXTRACT(jsonPayload.title)"
        #   description = "EXTRACT(jsonPayload.description)"
        # }
      }
    }
  }
}
