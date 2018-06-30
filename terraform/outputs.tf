output "app_external_ip" {
  value = "${google_compute_instance.app.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "fr_IP" {
  value = "${google_compute_forwarding_rule.fr.ip_address}"
}
