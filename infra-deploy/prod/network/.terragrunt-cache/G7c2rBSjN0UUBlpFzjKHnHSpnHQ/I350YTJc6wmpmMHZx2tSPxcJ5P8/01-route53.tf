resource "aws_route53_zone" "this" {
  name = var.domain_name    # Replace with the domain name you own
}

resource "aws_route53_record" "this" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name      # Domain you own (e.g., example.com)
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}