output "targetGroup-ARN" {
  value = aws_alb_target_group.albTargetGroup.arn
}

output "albDNSName" {
  value = aws_alb.applicationLoadBalancer.dns_name
}