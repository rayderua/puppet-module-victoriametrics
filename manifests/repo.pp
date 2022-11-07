class victoriametrics::repo {
  ensure_resource('apt::source', $::victoriametrics::repo_source)
}