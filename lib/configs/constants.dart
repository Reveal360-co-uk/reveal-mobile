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
    BuiltInModelFile(name: "Blue", path: "assets/blue.glb"),
    BuiltInModelFile(name: "Tiger", path: "assets/tiger.glb"),
    BuiltInModelFile(name: "Coffin", path: "assets/coffin.glb"),
    BuiltInModelFile(name: "Mummy", path: "assets/mummy.glb"),
    BuiltInModelFile(name: "Vase", path: "assets/vase.glb"),
    BuiltInModelFile(name: "DecoratedVase", path: "assets/DecoratedVase.glb"),
    BuiltInModelFile(name: "Emperor", path: "assets/emperor.glb"),
  ];

  // ignore: non_constant_identifier_names
  static List<Questions> QUESTIONS = [
    Questions(question: "hi", answer: "Hey"),
    Questions(question: "hello", answer: "Hey"),
    Questions(question: "how are you", answer: "I am great, how are you?"),
    Questions(question: "what is your name", answer: "I am #name"),
    Questions(
      question: "can you tell me what is today's date",
      answer:
          "Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
    ),
    Questions(question: "Bye", answer: "See you later"),
  ];
}
