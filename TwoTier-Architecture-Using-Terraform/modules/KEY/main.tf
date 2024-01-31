resource "aws_key_pair" "clientKey" {
  key_name = "clientKey"
  public_key = file("../modules/KEY/clientKey.pub")
}