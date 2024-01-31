output "cloudFront-DomainName" {
  value = aws_cloudfront_distribution.applicationDistribution.domain_name
}

output "cloudFront-Id" {
  value = aws_cloudfront_distribution.applicationDistribution.id
}

output "cloudFront-ARN" {
  value = aws_cloudfront_distribution.applicationDistribution.arn
}

output "cloudFront_STATUS" {
  value = aws_cloudfront_distribution.applicationDistribution.status
}

output "cloudFront_HOSTED_ZONE_ID" {
  value = aws_cloudfront_distribution.applicationDistribution.hosted_zone_id
}