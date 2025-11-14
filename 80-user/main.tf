module "user" {
    source =  "git::https://github.com/muralipydi-source/terraform-aws-roboshop.git?ref=main" #"../../terraform-aws-roboshop"
    component = "user"
    rule_priority = 20
}

 #"git::https://github.com/muralipydi-source/terraform-aws-securitygroup.git?ref=main"