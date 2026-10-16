resource "aws_instance" "k8s-master" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.k8s-sg.id]
  subnet_id                   = aws_subnet.k8s-public-subnet.id
  associate_public_ip_address = true
  user_data                   = file("${path.module}/scripts/cloud_init_master.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "k8s-worker" {
  count                       = 2
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.k8s-sg.id]
  subnet_id                   = aws_subnet.k8s-public-subnet.id
  associate_public_ip_address = true
  user_data                   = file("${path.module}/scripts/cloud_init_worker.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }
  tags = {
    Name = "worker-${count.index + 1}"
  }
}

resource "aws_eip" "k8s-master-eip" {
  domain   = "vpc"
  instance = aws_instance.k8s-master.id

  tags = {
    Name = "k8s-master-eip"
  }
}

resource "aws_eip" "k8s-worker-eip" {
  count    = 2
  domain   = "vpc"
  instance = aws_instance.k8s-worker[count.index].id

  tags = {
    Name = "k8s-worker-eip-${count.index + 1}"
  }
}