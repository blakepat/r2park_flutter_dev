

bool isNullOrEmpty(String? str) {
  if (str != null) {
    if (str.isEmpty || str == '') return true;
    return false;
  }
  return true;
}
