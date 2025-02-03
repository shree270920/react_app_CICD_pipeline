#(aws_instance resource)
resource "aws_instance" "web" {
  ami           = "ami-00c257e12d6828491" #ami ID from when v give launch instance in console
  instance_type = "t3.medium"
  # count = 5 #When 5 instnaces need to be created 

  # Method 1 for Keypair by creating it in aws console and attaching it in terraform
   key_name = "demo"  #it is in /home/divya with chmod 400 done
  tags = {
    Name = "HelloWorld" #EC2 instance name
  }
}

  # Method 2 for Keypair directly from terraform registry 
  #(aws_key_pair resource) PUBLIC KEY STORE IN AWS
# resource "aws_key_pair" "TF_Key" {
#   key_name   = "TF_Key"
#   public_key = tls_private_key.rsa.public_key_openssh #Search (tls_private_key)
# }
# # (tls_private_key resource & choose rsa algorithm)
# # RSA key of size 4096 bits
# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# #(local_file resource) to store the key pair value 
# #PRIVATE KEY STORE IN MY MACHINE
# resource "local_file" "TF_Key" {
#   content  = tls_private_key.rsa.private_key_pem
#   filename = "tfkey"
# }

#Security group using terraform 
#(aws_security_group resource)
resource "aws_security_group" "TF_SG" {
  name        = "Security_group_using_terraform"
  description = "Security group using terraform"
  vpc_id      = "vpc-0c65d547d904fa2ce"
  #vpc_id      = aws_vpc.main.id # when  v have vpc created using TF itself v can use this data block

  tags = {
    Name = "allow_tls"
  }
}
#Ingress => Inbound rules
resource "aws_vpc_security_group_ingress_rule" "https" {
  description       = "HTTPS"
  security_group_id = "sg-0ad18b7eae9726b3a"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "http" {
  description       = "HTTP"
  security_group_id = "sg-0ad18b7eae9726b3a"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  description       = "SSH"
  security_group_id = "sg-0ad18b7eae9726b3a"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


#egress => Outbound rules
# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
#   security_group_id = aws_security_group.allow_tls.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }