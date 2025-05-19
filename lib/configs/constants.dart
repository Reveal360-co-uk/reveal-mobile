import 'package:reveal/configs/types.dart';

class AppConstants {
  // ignore: non_constant_identifier_names
  static List<BuiltInModelFile> BUILT_IN_MODELS = [
    BuiltInModelFile(name: "Apple", path: "assets/apple.dae", isDae: true),
    BuiltInModelFile(name: "Box", path: "assets/Box.gltf"),
    BuiltInModelFile(name: "Sample", path: "assets/sample.glb"),
    BuiltInModelFile(name: "Earth", path: "assets/earth.glb"),
    BuiltInModelFile(name: "Model", path: "assets/model.gltf"),
    BuiltInModelFile(name: "Talking", path: "assets/talking.glb"),
    BuiltInModelFile(name: "Fox", path: "assets/fox.glb"),
    BuiltInModelFile(name: "Fox DAE", path: "assets/fox.dae", isDae: true),
  ];
}
