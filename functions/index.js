const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_51R9CUTHKDwKFlmiwbFnTNW8V8VlC5YT7eA6kzcANL0s1CDt1PT4xhmEXBcBrzoD2eSvIfRwjLwHapsvQPholyaN900zDgj7yVd");

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  try {
    const { amount, currency } = data;

    if (!amount || !currency) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Amount and currency are required."
      );
    }

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, // Amount in cents
      currency: currency,
      payment_method_types: ["card"],
    });

    return { clientSecret: paymentIntent.client_secret };
  } catch (error) {
    console.error("Payment Intent Error:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});
