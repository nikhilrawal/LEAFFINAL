import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:leafapp/pages/subsciption/subciption.dart';
import 'package:url_launcher/url_launcher.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  bool _isSubscribed = false;
  final List<Doctor> _doctors = [
    Doctor(
      name: "Dr. Rajesh Kumar",
      qualification: "PhD in Plant Pathology",
      specialty: "Crop Diseases",
      experience: "12 years",
      whatsapp: "+919876543210",
      image: "images/doctor1.jfif",
    ),
    Doctor(
      name: "Dr. Krishan Sharma",
      qualification: "MSc in Agricultural Science",
      specialty: "Organic Farming",
      experience: "8 years",
      whatsapp: "+919876543211",
      image: "images/doctor10.jfif",
    ),
    Doctor(
      name: "Dr. Amit Patel",
      qualification: "PhD in Horticulture",
      specialty: "Fruit Crops",
      experience: "15 years",
      whatsapp: "+919876543212",
      image: "images/doctor3.jfif",
    ),
    Doctor(
      name: "Dr. Sunita Reddy",
      qualification: "MSc in Soil Science",
      specialty: "Soil Nutrition",
      experience: "10 years",
      whatsapp: "+919876543213",
      image: "images/doctor4.jfif",
    ),
    Doctor(
      name: "Dr. Vikram Singh",
      qualification: "PhD in Agronomy",
      specialty: "Cereal Crops",
      experience: "18 years",
      whatsapp: "+919876543214",
      image: "images/doctor5.jfif",
    ),
    Doctor(
      name: "Dr. Anupam Gupta",
      qualification: "MSc in Plant Breeding",
      specialty: "Hybrid Crops",
      experience: "7 years",
      whatsapp: "+919876543215",
      image: "images/doctor6.jfif",
    ),
    Doctor(
      name: "Dr. Smita Joshi",
      qualification: "PhD in Entomology",
      specialty: "Pest Management",
      experience: "14 years",
      whatsapp: "+919876543216",
      image: "images/doctor7.jfif",
    ),
    Doctor(
      name: "Dr. Mayur Iyer",
      qualification: "MSc in Agricultural Economics",
      specialty: "Farm Management",
      experience: "9 years",
      whatsapp: "+919876543217",
      image: "images/doctor4.jfif",
    ),
    Doctor(
      name: "Dr. Sanjay Verma",
      qualification: "PhD in Irrigation Science",
      specialty: "Water Management",
      experience: "16 years",
      whatsapp: "+919876543218",
      image: "images/doctor9.jfif",
    ),
    Doctor(
      name: "Dr. Anuj Desai",
      qualification: "MSc in Plant Biotechnology",
      specialty: "GM Crops",
      experience: "11 years",
      whatsapp: "+919876543219",
      image: "images/doctor11.jfif",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkSubscription();
  }

  Future<void> _checkSubscription() async {
    final userBox = await Hive.openBox('user');
    final email = userBox.get('email');
    final isSubscribed = userBox.get('isSubscribed', defaultValue: false);

    if (email != null && isSubscribed) {
      setState(() {
        _isSubscribed = true;
      });
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final url = "https://wa.me/$phone";
    final Uri url2 = Uri.parse(url);
    if (await canLaunchUrl(url2)) {
      await launchUrl(url2);
    } else {
      throw 'Could not launch $url2';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agricultural Experts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          _isSubscribed
              ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _doctors.length,
                itemBuilder: (context, index) {
                  final doctor = _doctors[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage(doctor.image),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctor.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      doctor.qualification,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Specialty: ${doctor.specialty}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Experience: ${doctor.experience}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () => _launchWhatsApp(doctor.whatsapp),
                              child: const Text(
                                "Chat Now",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Subscribe to access our agricultural experts",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to subscription screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriptionScreen(),
                          ),
                        );
                      },
                      child: const Text("Subscribe Now"),
                    ),
                  ],
                ),
              ),
    );
  }
}

class Doctor {
  final String name;
  final String qualification;
  final String specialty;
  final String experience;
  final String whatsapp;
  final String image;

  Doctor({
    required this.name,
    required this.qualification,
    required this.specialty,
    required this.experience,
    required this.whatsapp,
    required this.image,
  });
}
