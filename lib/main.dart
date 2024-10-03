import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_text_detect_area/flutter_text_detect_area.dart';
import 'package:image_picker/image_picker.dart';
import 'package:autocorrect_and_autocomplete_engine/autocorrect_and_autocomplete_engine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scholar Threads Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Scholar Threads Prototype'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Variables and what-not
  String detectedValue = "";
  String cameraDetectedValue = "";
  bool enableImageInteractions = true;

  String _autoCorrectBuilder(String str) {
    TrieEngine trieEngine = TrieEngine(src: List.empty());
    List<String> text = str.split(' ');
    String ret = '';
    for (var word in text) {
      trieEngine.insertWord(word);
      List<String> result = trieEngine.autoCompleteSuggestions(word);
      if (result[0] != null) {
        ret += (result[0] + ' '); //Add result to ret
      }
      trieEngine = TrieEngine(src: List.empty()); //Reset
    }
    return ret;
  }

  TextRecognitionScript initialRecognitionScript = TextRecognitionScript.latin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RippleButton(
                    margin: const EdgeInsets.all(20),
                    bgColor: Colors.lightBlue,
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          detectedValue = cameraDetectedValue = "";
                        });
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelectImageAreaTextDetect(
                                  showLangScriptDropDown: true,
                                  detectOnce: true,
                                  enableImageInteractions:
                                      enableImageInteractions,
                                  imagePath: pickedFile?.path ?? '',
                                  onDetectText: (v) {
                                    setState(() {
                                      if (v is String) {
                                        detectedValue = v;
                                      }
                                      if (v is List) {
                                        int counter = 0;
                                        for (var element in v) {
                                          detectedValue +=
                                              "$counter. \t\t $element \n\n";
                                          counter++;
                                        }
                                      }
                                    });
                                  },
                                  onDetectError: (error) {
                                    print(error);

                                    if (error is PlatformException &&
                                        (error.message?.contains(
                                                "InputImage width and height should be at least 32!") ??
                                            false)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Selected area should be able to crop image with at least 32 width and height.")));
                                    }
                                  },
                                )));
                      },
                      child: const Center(
                          child: Text(
                        "Choose Image",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                    )),
                // const SizedBox(height: 20),

                const SizedBox(height: 20),
                Text('Detected Text',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Flexible(
                    child: SingleChildScrollView(
                        child: Text(
                            detectedValue.isEmpty && cameraDetectedValue.isEmpty
                                ? ""
                                : cameraDetectedValue.isNotEmpty
                                    ? cameraDetectedValue
                                    : detectedValue,
                            style: Theme.of(context).textTheme.bodyMedium))),

                Text('Autocorrected Text',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Flexible(
                    child: SingleChildScrollView(
                        child: Text(
                            detectedValue.isEmpty && cameraDetectedValue.isEmpty
                                ? ""
                                : cameraDetectedValue.isNotEmpty
                                    ? cameraDetectedValue
                                    : _autoCorrectBuilder(detectedValue),
                            style: Theme.of(context).textTheme.bodyMedium)))
              ],
            ),
          ),
        ));
  }
}
