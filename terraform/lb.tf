resource "google_compute_http_health_check" "hcheck" {
  name = "hcheck"

  timeout_sec        = 1
  check_interval_sec = 1
  
  port = "9292"
}

resource "google_compute_target_pool" "tp" {
  name = "tp"
  instances = ["${google_compute_instance.app.*.self_link}"]
  health_checks = ["${google_compute_http_health_check.hcheck.name}"]
}

resource "google_compute_forwarding_rule" "fr" {
  name       = "fr"
  target     = "${google_compute_target_pool.tp.self_link}"
  port_range = "9292"
}

