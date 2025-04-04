import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/screens/initial_screens/cart_screen.dart';

class SupplementShopScreen extends StatelessWidget {
  const SupplementShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SUPPLEMENT SHOP',
          style: kAppBarTextStyle,
        ),
        automaticallyImplyLeading: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              Positioned(
                right: 0,
                top: 0,
                child: StreamBuilder<int>(
                  stream: getCartItemCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    final itemCount = snapshot.data ?? 0;
                    return itemCount > 0
                        ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        itemCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                        : const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: const SupplementShopBody(),
    );
  }

  String getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      throw Exception("User is not logged in or does not have an email");
    }
    return user.email!;
  }

  Stream<int> getCartItemCount() {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(getUserEmail());
    return userDoc.collection('cart').snapshots().map((snapshot) => snapshot.docs.length);
  }
}

class SupplementShopBody extends StatefulWidget {
  const SupplementShopBody({super.key});

  @override
  State<SupplementShopBody> createState() => _SupplementShopBodyState();
}

class _SupplementShopBodyState extends State<SupplementShopBody> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Supplement> supplements = [
    Supplement(
      name: 'Whey Protein',
      brand: 'MuscleTech',
      price: 39.99,
      rating: 4.5,
      imageUrl: 'images/whey.jpg',
      category: 'Protein',
      description: 'Premium whey protein powder for muscle recovery and growth',
      benefits: ['Muscle growth', 'Recovery', 'Lean protein source'],
    ),
    Supplement(
      name: 'Creatine Monohydrate',
      brand: 'Optimum Nutrition',
      price: 24.99,
      rating: 4.8,
      imageUrl: 'images/Creatine.jpg',
      category: 'Performance',
      description: 'Pure creatine monohydrate for strength and power',
      benefits: ['Strength gains', 'Power output', 'Muscle endurance'],
    ),
    Supplement(
      name: 'Multivitamin',
      brand: 'Nature Made',
      price: 15.99,
      rating: 4.2,
      imageUrl: 'images/Multivitamin.jpg',
      category: 'Vitamins',
      description: 'Complete multivitamin for overall health',
      benefits: ['Immune support', 'Energy production', 'Nutrient coverage'],
    ),
    Supplement(
      name: 'BCAA Powder',
      brand: 'Scivation',
      price: 29.99,
      rating: 4.3,
      imageUrl: 'images/BCAA Powder.jpg',
      category: 'Amino Acids',
      description: 'Branch chain amino acids for muscle preservation',
      benefits: ['Muscle recovery', 'Endurance', 'Reduce fatigue'],
    ),
    Supplement(
      name: 'Fish Oil',
      brand: 'Nordic Naturals',
      price: 19.99,
      rating: 4.7,
      imageUrl: 'images/FishOil.jpg',
      category: 'Omega-3',
      description: 'Ultra pure fish oil for heart and brain health',
      benefits: ['Heart health', 'Brain function', 'Joint support'],
    ),
    Supplement(
      name: 'Pre-Workout',
      brand: 'C4 Sport',
      price: 34.99,
      rating: 4.6,
      imageUrl: 'images/PreWorkout.jpg',
      category: 'Pre-Workout',
      description: 'Energy and endurance booster for intense workouts',
      benefits: ['Energy boost', 'Focus', 'Performance'],
    ),
  ];

  final List<String> categories = [
    'All',
    'Protein',
    'Pre-Workout',
    'Vitamins',
    'Amino Acids',
    'Omega-3',
    'Performance'
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    final filteredSupplements = supplements.where((supplement) {
      final matchesCategory = _selectedCategory == 'All' || supplement.category == _selectedCategory;
      final matchesSearch = _searchController.text.isEmpty ||
          supplement.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          supplement.brand.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.04,
                    vertical: 16,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search supplements...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Text(categories[index]),
                          selected: _selectedCategory == categories[index],
                          selectedColor: kAppThemeColor,
                          labelStyle: TextStyle(
                            color: _selectedCategory == categories[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (selected) => setState(() {
                            _selectedCategory = selected ? categories[index] : 'All';
                          }),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [kAppThemeColor, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SUMMER SALE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Up to 30% OFF on selected items',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'SHOP NOW',
                              style: TextStyle(color: kAppThemeColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isPortrait ? 2 : 3,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredSupplements.length,
                    itemBuilder: (context, index) {
                      final supplement = filteredSupplements[index];
                      return SupplementCard(
                        supplement: supplement,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return SupplementDetailSheet(supplement: supplement);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20), // Extra padding at bottom
              ],
            ),
          ),
        );
      },
    );
  }
}

class SupplementCard extends StatelessWidget {
  final Supplement supplement;
  final VoidCallback onTap;

  const SupplementCard({
    required this.supplement,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset( // Changed from Image.network to Image.asset
                  supplement.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          supplement.brand,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: kAppThemeColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          supplement.category,
                          style: TextStyle(
                            color: kAppThemeColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    supplement.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        supplement.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${supplement.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kAppThemeColor,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        color: kAppThemeColor,
                        iconSize: 20,
                        onPressed: () async {
                          try {
                            final userDoc = FirebaseFirestore.instance
                                .collection('users')
                                .doc(getUserEmail());
                            final cartRef = userDoc.collection('cart').doc(supplement.name);
                            await cartRef.set({
                              'id': supplement.name,
                              'name': supplement.name,
                              'brand': supplement.brand,
                              'price': supplement.price,
                              'imageUrl': supplement.imageUrl,
                              'quantity': 1,
                            }, SetOptions(merge: true));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Added ${supplement.name} to cart')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error adding to cart: $e')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      throw Exception("User is not logged in or does not have an email");
    }
    return user.email!;
  }
}

class SupplementDetailSheet extends StatelessWidget {
  final Supplement supplement;

  const SupplementDetailSheet({required this.supplement, super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset( // Changed from Image.network to Image.asset
                supplement.imageUrl,
                height: screenSize.height * 0.25,
                width: screenSize.width * 0.6,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: screenSize.height * 0.25,
                  width: screenSize.width * 0.6,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            supplement.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            supplement.brand,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                  supplement.rating.toStringAsFixed(1)),
              const Spacer(),
              Text(
                '\$${supplement.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: kAppThemeColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            supplement.description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Key Benefits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: supplement.benefits.map((benefit) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      benefit,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              try {
                final userDoc = FirebaseFirestore.instance
                    .collection('users')
                    .doc(getUserEmail());
                final cartRef = userDoc.collection('cart').doc(supplement.name);
                await cartRef.set({
                  'id': supplement.name,
                  'name': supplement.name,
                  'brand': supplement.brand,
                  'price': supplement.price,
                  'imageUrl': supplement.imageUrl,
                  'quantity': 1,
                }, SetOptions(merge: true));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added ${supplement.name} to cart')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding to cart: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kAppThemeColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'ADD TO CART',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16), // Extra padding at bottom
        ],
      ),
    );
  }

  String getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      throw Exception("User is not logged in or does not have an email");
    }
    return user.email!;
  }
}

class Supplement {
  final String name;
  final String brand;
  final double price;
  final double rating;
  final String imageUrl;
  final String category;
  final String description;
  final List<String> benefits;

  Supplement({
    required this.name,
    required this.brand,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.benefits,
  });
}