import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leafapp/pages/chatbotui/chat.dart';
import 'package:leafapp/widgets/staticfile.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddWallpaper extends StatefulWidget {
  const AddWallpaper({super.key});

  @override
  State<AddWallpaper> createState() => _AddWallpaperState();
}

class _AddWallpaperState extends State<AddWallpaper> {
  List<String> categories = [
    'Disease',
    'Pest',
    'Which plant is this?',
    'Overall Health',
    'Common Information',
  ];
  bool search = false;
  String? value;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  Future getImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  final String _geminiApiKey = geminiApiKey; // Replace with your actual API key
  String _analysisResult = "";
  bool _isAnalyzing = false;

  Future<void> analyzeImageWithGemini(String category) async {
    if (selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
      _analysisResult = "";
    });

    try {
      // Initialize the Gemini model
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _geminiApiKey,
      );

      // Prepare the prompt based on category
      String prompt;
      switch (category) {
        case 'Disease':
          prompt =
              "Analyze this plant image and identify any diseases. "
              "Provide details about the disease, its symptoms, and treatment options.";
          break;
        case 'Pest':
          prompt =
              "Examine this plant image for pest infestations. "
              "Identify the pests and suggest organic and chemical control methods.";
          break;
        case 'Which plant is this?':
          prompt =
              "Identify the plant species in this image. "
              "Provide its common name, scientific name, and basic care information.";
          break;
        case 'Overall Health':
          prompt =
              "Assess the overall health of this plant. "
              "Identify any issues and provide care recommendations to improve its health.";
          break;
        case 'Common Information':
          prompt =
              "Provide comprehensive information about this plant "
              "including species, care requirements, common problems, and solutions.";
          break;
        default:
          prompt = "Analyze this plant image and provide relevant information.";
      }

      // Get image bytes
      final imageBytes = await selectedImage!.readAsBytes();

      // Generate content
      final content = [
        Content.multi([TextPart(prompt), DataPart('image/jpeg', imageBytes)]),
      ];

      final response = await model.generateContent(content);

      setState(() {
        _analysisResult = response.text ?? "No analysis available";
        _isAnalyzing = false;
      });

      // Show the result
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.eco, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    "Analysis Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        _analysisResult.length > 250
                            ? '${_analysisResult.substring(0, 250).trim()}...'
                            : _analysisResult,
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                    if (_analysisResult.length > 250) ...[
                      SizedBox(height: 12),
                      Text(
                        'Showing preview only',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ChatPage(initialMessage: _analysisResult),
                      ),
                    );
                  },
                  child: Text(
                    "View Full Analysis",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            ),
      );
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _analysisResult = "Error analyzing image: ${e.toString()}";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Analysis failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  uploadItem(String category) async {
    if (selectedImage != null && value != null) {
      setState(() {
        search = true;
      });

      await analyzeImageWithGemini(category);

      setState(() {
        search = false;
      });

      Fluttertoast.showToast(
        msg: "Analysis completed successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.blueGrey,
          ),
        ),
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            'Add plant image',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 30),
            selectedImage == null
                ? GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 250,
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.add_a_photo_outlined),
                      ),
                    ),
                  ),
                )
                : Center(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 250,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  borderRadius: BorderRadius.circular(10),
                  value: value,
                  hint: Text(
                    "Select category of information",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  onChanged: (value) {
                    setState(() {
                      this.value = value;
                    });
                  },
                  items:
                      categories
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                              value: e,
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
            SizedBox(height: 40),
            search
                ? SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'We are working for your request\nKindly Wait',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              strokeWidth: 8,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.teal,
                              ),
                            ),
                            Text('⏳', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                : GestureDetector(
                  onTap: () {
                    if (value != null && selectedImage != null) {
                      setState(() {
                        search = true;
                      });
                      uploadItem(value!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Select image and category',
                            style: TextStyle(fontSize: 24),
                          ),
                          backgroundColor: Colors.orangeAccent,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
