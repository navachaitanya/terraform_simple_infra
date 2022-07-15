##local variables and their manipulation are here
locals {
  app_eks_target_groups_name = "tg-${var.app_environment}"

  ec2_host_group = {
    primary   = "0"
    secondary = "1"
  }

  #app_instances = ["one"]
  ec2_userdata_scripts = filebase64("resources/bootstrap_scripts/bootstrap_script.sh")
  tags = {
    #Managed_by= "terraform"
  }
}
