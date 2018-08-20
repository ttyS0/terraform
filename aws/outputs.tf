output "kmjohnson-net_ns" {
  value = "${aws_route53_zone.kmjohnson-net.name_servers}"
}

output "gutenpress-org_ns" {
  value = "${aws_route53_zone.gutenpress-org.name_servers}"
}

output "vumc-cloud_ns" {
  value = "${aws_route53_zone.vumc-cloud.name_servers}"
}
