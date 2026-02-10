
# Mock the Google provider so we don't need real credentials
mock_provider "google" {}

# Test Case 1: Production (pd)
# Should NOT create `citi_apigee_environments`
# Should resolve folder ID via `citi_apigee_base`
run "folder_lookup_pd" {
  command = plan

  variables {
    domain                   = "citi.com"
    project_id               = "test-proj-pd"
    project_name             = "test-pd"
    billing_account          = "000000-000000-000000"
    platform_environment     = "production"
    env_code                 = "pd"
    usecase_fldr             = "apigee-hybrid/smb-cts"
    
    # Defaults for required vars
    activate_apis            = []
  }

  # Assert that the `citi_apigee_environments` data source is NOT created
  assert {
    condition     = length(data.google_active_folder.citi_apigee_environments) == 0
    error_message = "Production (pd) should not trigger creation of citi_apigee_environments data source"
  }

  # Assert that we successfully resolved a folder ID (meaning the map lookup worked)
  assert {
    condition     = local.resolved_folder_id != null
    error_message = "Production (pd) folder path lookup failed in locals"
  }
}

# Test Case 2: Non-Production (np)
# Should create `citi_apigee_environments` because env_code is "np"
run "folder_lookup_np" {
  command = plan

  variables {
    domain                   = "citi.com"
    project_id               = "test-proj-np"
    project_name             = "test-np"
    billing_account          = "000000-000000-000000"
    platform_environment     = "non-production"
    env_code                 = "np"
    usecase_fldr             = "apigee-hybrid/smb-cts/cte" # Testing a deep nested path
    
    # Defaults for required vars
    activate_apis            = []
  }

  # Assert that the `citi_apigee_environments` data source IS created
  assert {
    condition     = length(data.google_active_folder.citi_apigee_environments) > 0
    error_message = "Non-Production (np) MUST create citi_apigee_environments data source"
  }
  
  # Assert that we successfully resolved a folder ID
  assert {
    condition     = local.resolved_folder_id != null
    error_message = "Non-Production (np) folder path lookup failed in locals"
  }
}

# Test Case 3: Service Engineering (se)
# Should NOT create `citi_apigee_environments` (similar to pd)
run "folder_lookup_se" {
  command = plan

  variables {
    domain                   = "citi.com"
    project_id               = "test-proj-se"
    project_name             = "test-se"
    billing_account          = "000000-000000-000000"
    platform_environment     = "service-engineering"
    env_code                 = "se"
    usecase_fldr             = "apigee-hybrid" # SE usually just uses base
    
    # Defaults for required vars
    activate_apis            = []
  }

  # Assert that the `citi_apigee_environments` data source is NOT created
  # This verifies our fix works for `se` as well as `pd`
  assert {
    condition     = length(data.google_active_folder.citi_apigee_environments) == 0
    error_message = "Service Engineering (se) should not trigger creation of citi_apigee_environments data source"
  }
}
