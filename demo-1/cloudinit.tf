data "template_file" "init-script" {
  template = file("scripts/init.sh")
}

data "template_file" "shell-script" {
  template = file("scripts/volumes.sh")

  vars = {
    DEVICE = var.VOLUME_NAME
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}
