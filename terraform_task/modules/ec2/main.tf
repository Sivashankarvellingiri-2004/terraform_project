resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "windows_vm" {
 
  ami                    = "ami-01a15dfc48279bf55" 
 
  instance_type          = "t3.micro"
 
  subnet_id              = var.subnet_ids[0]
 
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
 
  associate_public_ip_address = true
 
  key_name = "windows_vm"
 
  # ---------------- USER DATA (Set Username & Password) ----------------
 
  user_data = <<-EOF
<powershell>
 
net user AdminUser P@ssw0rd123! /add
 
net localgroup administrators AdminUser /add
 
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
 
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
</powershell>
 
 
  EOF
 
  tags = {
 
    Name = "Windows-VM"
 
  }
 
}