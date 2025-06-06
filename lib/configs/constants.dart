import 'package:flutter/material.dart';
import 'package:reveal/configs/types.dart';

class AppConstants {
  // ignore: non_constant_identifier_names
  static List<BuiltInModelFile> BUILT_IN_MODELS = [
    // BuiltInModelFile(name: "Apple", path: "assets/apple.dae", isDae: true),
    // BuiltInModelFile(name: "Box", path: "assets/Box.gltf"),
    // BuiltInModelFile(name: "Sample", path: "assets/sample.glb"),
    // BuiltInModelFile(name: "Earth", path: "assets/earth.glb"),
    // BuiltInModelFile(name: "Model", path: "assets/model.gltf"),
    // BuiltInModelFile(name: "Talking", path: "assets/talking.glb"),
    // BuiltInModelFile(name: "Fox", path: "assets/fox.glb"),
    // BuiltInModelFile(name: "Fox DAE", path: "assets/fox.dae", isDae: true),
    // BuiltInModelFile(name: "Blue", path: "assets/blue.glb"),
    // BuiltInModelFile(name: "Tiger", path: "assets/tiger.glb"),
    // BuiltInModelFile(name: "Coffin", path: "assets/coffin.glb"),
    // BuiltInModelFile(name: "Mummy", path: "assets/mummy.glb"),
    // BuiltInModelFile(name: "Vase", path: "assets/vase.glb"),
    // BuiltInModelFile(name: "DecoratedVase", path: "assets/DecoratedVase.glb"),
    // BuiltInModelFile(name: "Emperor", path: "assets/emperor.glb"),
    BuiltInModelFile(
      name: "Plesiosaur",
      path: "assets/plesiosaurus.glb",
      description: [
        "Hi there,",
        "My name is Plesiosaurs",
        "I am a marine reptile that lived during the Mesozoic era.",
        "I am known for my long neck, small head, and large body.",
        "Plesiosaurs were not dinosaurs, but they lived during the same time period.",
        "I am often depicted as a sea monster in popular culture, but I was actually a gentle giant that fed on fish and other marine animals.",
        "Plesiosaurs had four flippers that allowed them to swim gracefully through the water.",
        "I am a fascinating creature that has captured the imagination of people for generations.",
      ],
    ),
    BuiltInModelFile(
      name: "Woman",
      path: "assets/woman.glb",
      description: [
        "Hi there,",
        "My name is Nisha",
        "I love to wear Saari",
        "Saari is a symbol of tradition and is deeply rooted in Indian culture.",
        "It is worn on various occasions, from weddings to festivals, and is often passed down through generations.",
        "The saari is not just a piece of clothing; it is a representation of grace, elegance, and the rich heritage of India.",
      ],
    ),
    // BuiltInModelFile(
    //   name: "Business Woman",
    //   path: "assets/women_talking.glb",
    //   description: ["Hi there,", "My name is Nisha", "I love to wear saaree"],
    // ),
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
    Questions(question: "bye", answer: "See you later"),
  ];

  // ignore: non_constant_identifier_names
  static List<BottomMenuItem> BOTTOM_MENU_ITEMS =
      [
        BottomMenuItem(title: "Back", icon: Icons.square),
        BottomMenuItem(title: "Talk", icon: Icons.mic),
        BottomMenuItem(title: "About", icon: Icons.info),
      ].toList();
}
