output "tags" {
   value = tomap(data.external.git.result)
}

output "tags_minimal" {
   value = tomap(data.external.git_minimal.result)
}
