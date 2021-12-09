
resource "aws_instance" "web_server" {
  count           = var.instance_count
  ami             = var.ami
  subnet_id       = var.subnet[count.index]
  security_groups = [var.security_group]
  instance_type   = var.type
  key_name        = var.keypair
  user_data       = templatefile("startup.sh.tpl", { rds_host = var.dbhost })

  tags = merge({ "Name" = var.name }, var.tags)

}