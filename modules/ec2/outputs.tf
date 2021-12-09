output "instance_id" {
  value = [for k, v in aws_instance.web_server : v.id]
}