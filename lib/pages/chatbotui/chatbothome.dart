// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:leafapp/pages/chatbotui/chat.dart';
// import 'package:leafapp/pages/login/admin_login.dart';
import 'package:leafapp/widgets/gradient_text.dart';
// Import your Gemini API service
// import 'package:leafapp/services/gemini_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showDropdown = false;
  int _selectedTabIndex = 0;
  bool _isLoading = false;

  // Organized data
  final List<String> _cropsPlants = [
    "Apple",
    "Banana",
    "Barley",
    "Basil",
    "Broccoli",
    "Cabbage",
    "Carrot",
    "Coffee",
    "Corn",
    "Cotton",
    "Cucumber",
    "Grapes",
    "Lettuce",
    "Mango",
    "Oats",
    "Onion",
    "Orange",
    "Peach",
    "Peanut",
    "Pear",
    "Pepper",
    "Potato",
    "Rice",
    "Rye",
    "Soybean",
    "Spinach",
    "Strawberry",
    "Sugarcane",
    "Sunflower",
    "Tea",
    "Tomato",
    "Wheat",
    "Watermelon",
  ]..sort();

  final List<String> _diseases = [
    "Anthracnose",
    "Bacterial spot",
    "Bacterial wilt",
    "Black spot",
    "Blight",
    "Botrytis",
    "Canker",
    "Clubroot",
    "Damping off",
    "Downy mildew",
    "Fire blight",
    "Fusarium wilt",
    "Gummosis",
    "Leaf curl",
    "Leaf spot",
    "Mosaic virus",
    "Powdery mildew",
    "Root rot",
    "Rust",
    "Scab",
    "Verticillium wilt",
  ]..sort();

  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChange);
    _filteredItems = _cropsPlants; // Default to crops/plants
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChange);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      setState(() => _showDropdown = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems =
          (_selectedTabIndex == 0 ? _cropsPlants : _diseases)
              .where((item) => item.toLowerCase().contains(query))
              .toList();
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
      _filteredItems = index == 0 ? _cropsPlants : _diseases;
      _searchController.clear();
    });
  }

  Future<void> _fetchAndNavigate(String query) async {
    setState(() => _isLoading = true);

    try {
      // Fetch response from Gemini API
      // final String response = await GeminiService.getResponse(query);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(sendfirstprompt: query),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching data: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Collapse dropdown when tapping outside
        if (_showDropdown) {
          setState(() => _showDropdown = false);
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "AI ChatBot",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Your existing card widget
              Card(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF69170), Color(0xFF7D96E6)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16.0, left: 16.0),
                            child: Text(
                              "Hi! You Can Ask Me",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text(
                              "Anything",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 16.0,
                              bottom: 16.0,
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const ChatPage(firsttime: true),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                      Colors.black,
                                    ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: GradientText(
                                  "Ask Now",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFF69170),
                                      Color(0xFF7D96E6),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            image: DecorationImage(
                              image: AssetImage("images/images.jfif"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: SizedBox(height: 95, width: 85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Search about crops, plants, and more",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              // Tab bar
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      onTap: _onTabChanged,
                      tabs: const [
                        Tab(text: 'Crops/Plants'),
                        Tab(text: 'Diseases'),
                      ],
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffececf8),
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onTap: () => setState(() => _showDropdown = true),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _fetchAndNavigate(value);
                              }
                            },
                            decoration: InputDecoration(
                              hintText:
                                  'Search ${_selectedTabIndex == 0 ? 'crops/plants' : 'diseases'}',
                              border: InputBorder.none,
                              suffixIcon:
                                  _searchController.text.isNotEmpty
                                      ? IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() => _showDropdown = false);
                                          _searchFocusNode.unfocus();
                                        },
                                      )
                                      : null,
                            ),
                          ),
                        ),
                        if (_showDropdown)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3,
                            ),
                            child:
                                _filteredItems.isEmpty
                                    ? const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text("No results found"),
                                    )
                                    : Scrollbar(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemCount: _filteredItems.length,
                                        itemBuilder: (context, index) {
                                          final item = _filteredItems[index];
                                          return ListTile(
                                            title: Text(item),
                                            onTap: () {
                                              _searchController.text = item;
                                              _fetchAndNavigate(item);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ), // Added padding between search and image
              Column(
                children: [
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 118, 126, 139),
                    shadowColor: Colors.amberAccent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const ChatPage(firsttime: true),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage('images/ai.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(width: 0.5),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(22, 255, 255, 255),
                            ),
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Talk to our AI ChatBot",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                color: const Color.fromARGB(207, 0, 0, 0),
                                fontSize: 18,
                                shadows: [
                                  Shadow(
                                    color: Colors.white,
                                    offset: Offset(0.5, 1.5),
                                  ),
                                  Shadow(
                                    color: Colors.blue,
                                    offset: Offset(0.8, 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
