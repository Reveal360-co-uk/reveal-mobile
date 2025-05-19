class BuiltInModelFile {
  final String name;
  final String path;
  final bool isDae;

  BuiltInModelFile({
    required this.name,
    required this.path,
    this.isDae = false,
  });
}
