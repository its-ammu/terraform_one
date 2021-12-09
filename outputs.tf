output "db_host" {
  value = aws_db_instance.db.address
}
output "alb_address" {
  value = aws_lb.alb.dns_name
}