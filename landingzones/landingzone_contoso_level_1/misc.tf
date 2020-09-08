#resource "azuread_group" "group" {
#    for_each                = var.rbacs
#    name                    = each.key
#}

#moduulissa
#variable "rbacs" {}

#rootissa
#variable "rbacs" {
#    description = "list of aad user groups and roles to be created"
#    type = set(string)
#}