provider "openstack" {
  user_name   = "testuser"
  tenant_name = "testProject"
  password    = "testuser"
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}

# set instance
resource "openstack_compute_instance_v2" "web1" {
  name            = "web1"
  image_name      = "centos7"
  flavor_name     = "myflavor"
  key_pair        = "testkey"
  security_groups = ["ssh/http/icmp"]
  network {
    name = "int-net"
  }

  depends_on = [
    openstack_networking_floatingip_v2.fip1,
  ]
}

resource "openstack_compute_instance_v2" "web2" {
  name            = "web2"
  image_name      = "centos7"
  flavor_name     = "myflavor"
  key_pair        = "testkey"
  security_groups = ["ssh/http/icmp"]
  network {
    name = "int-net"
  }

  depends_on = [
    openstack_networking_floatingip_v2.fip2,
  ]
}

# set fip 
resource "openstack_networking_floatingip_v2" "fip1" {
  pool = "public" # static setted
}

resource "openstack_networking_floatingip_v2" "fip2" {
  pool = "public" # static setted
}

# associate fip
resource "openstack_compute_floatingip_associate_v2" "webip1" {
  floating_ip = openstack_networking_floatingip_v2.fip1.address
  instance_id = openstack_compute_instance_v2.web1.id
}

resource "openstack_compute_floatingip_associate_v2" "webip2" {
  floating_ip = openstack_networking_floatingip_v2.fip2.address
  instance_id = openstack_compute_instance_v2.web2.id
}

