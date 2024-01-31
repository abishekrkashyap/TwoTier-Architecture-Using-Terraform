data "aws_route53_zone" "publicZone" {
  name = var.hosted_ZoneName
  private_zone = false
}

resource "aws_route53_record" "cloudFront-record" {
  zone_id = data.aws_route53_zone.publicZone.zone_id
  name = "week3.${data.aws_route53_zone.public-zone.name}"
  type = "A"

  alias {
    name =  var.cloudFront_DomainName
    zone_id = var.cloudFront_HostedZone-Id
    evaluate_target_health = false
  }
}
