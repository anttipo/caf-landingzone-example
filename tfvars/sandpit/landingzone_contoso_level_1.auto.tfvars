global_settings = {
  team_prefix        = "team" # Use this to describe what team or business unit owns the resources
  environment_prefix = "prod"    # Use this to describe the environment of the subscription (QA, DEV, PROD)
  location           = "westeurope"
  tags = {
    Environment  = "Sandbox"
    CostCenter    = "123456"
    Purpose       = "core infrastructure"
    ContactPerson = "john.doe@mail.com"
  }
}

logging_config = {
  activity_log_map = {
    log = [
      # ["Audit category name",  "Audit enabled)"] 
      ["Administrative", true],
      ["Security", true],
      ["ServiceHealth", true],
      ["Alert", true],
      ["Recommendation", true],
      ["Policy", true],
      ["Autoscale", true],
      ["ResourceHealth", true],
    ]
  }

  solution_plan_map = {
    NetworkMonitoring = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/NetworkMonitoring"
    }
  }
}

asc_config = {
  contact_email       = "john.doe@mail.com"
  contact_phone       = "+1234567890"
  alert_notifications = true
  alerts_to_admins    = true
}

policy_config = {
  allowed_locations = ["northeurope", "westeurope"]
}
