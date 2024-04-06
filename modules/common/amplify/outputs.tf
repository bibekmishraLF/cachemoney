output "amplify_app_id" {
  value = aws_amplify_app.fe.id
}

output "fe_url" {
  value = aws_amplify_app.fe.default_domain
}
