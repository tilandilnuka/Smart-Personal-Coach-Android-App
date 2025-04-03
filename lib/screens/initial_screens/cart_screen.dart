import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize Stripe
    Stripe.instance.applySettings();
  }

  // Helper function to get the current user's email
  String getUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      throw Exception("User is not logged in or does not have an email");
    }
    return user.email!;
  }

  // Stream to get the cart items
  Stream<List<Map<String, dynamic>>> getCartItems() {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(getUserEmail());
    return userDoc.collection('cart').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Create a PaymentIntent via Firebase Cloud Function
  Future<String> createPaymentIntent(int totalAmount, String currency) async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
      final response = await callable.call({
        'amount': totalAmount,
        'currency': currency,
      });

      if (response.data['clientSecret'] == null) {
        throw Exception("Failed to create payment intent: Missing clientSecret");
      }

      return response.data['clientSecret'];
    } catch (e) {
      throw Exception("Failed to create payment intent: $e");
    }
  }

  // Show Stripe Payment Sheet
  Future<void> checkout(List<Map<String, dynamic>> cartItems, double totalPrice) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 1️⃣ Create a PaymentIntent
      String clientSecret = await createPaymentIntent((totalPrice * 100).toInt(), 'usd');

      // 2️⃣ Initialize Stripe PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Suppliment Store",
          customerId: getUserEmail(),
        ),
      );

      // 3️⃣ Present the PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      // 4️⃣ Save Order to Firestore
      await saveOrderToFirestore(cartItems, totalPrice);

      // Hide loading indicator
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully')),
      );
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      // Handle Stripe payment failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  // Save order to Firestore after successful payment
  Future<void> saveOrderToFirestore(List<Map<String, dynamic>> cartItems, double totalPrice) async {
    try {
      final userEmail = getUserEmail();
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userEmail);

      // Save order details
      await userDoc.collection('orders').add({
        'items': cartItems,
        'totalPrice': totalPrice,
        'status': 'paid',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the cart
      await userDoc.collection('cart').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (e) {
      throw Exception("Failed to save order to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          } else {
            final cartItems = snapshot.data!;
            double totalPrice = cartItems.fold(
              0,
                  (total, item) => total + (item['price'] * item['quantity']),
            );
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item['imageUrl']),
                        ),
                        title: Text(item['name']),
                        subtitle: Text('\$${item['price'].toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                final newQuantity = (item['quantity'] as int) - 1;
                                if (newQuantity > 0) {
                                  updateCartItem(context, item['id'], newQuantity);
                                } else {
                                  removeCartItem(context, item['id']);
                                }
                              },
                            ),
                            Text('${item['quantity']}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                final newQuantity = (item['quantity'] as int) + 1;
                                updateCartItem(context, item['id'], newQuantity);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await checkout(cartItems, totalPrice);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'CHECKOUT',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // Update the quantity of a cart item
  Future<void> updateCartItem(BuildContext context, String itemId, int newQuantity) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(getUserEmail());
    await userDoc.collection('cart').doc(itemId).update({'quantity': newQuantity});
  }

  // Remove an item from the cart
  Future<void> removeCartItem(BuildContext context, String itemId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(getUserEmail());
    await userDoc.collection('cart').doc(itemId).delete();
  }
}
