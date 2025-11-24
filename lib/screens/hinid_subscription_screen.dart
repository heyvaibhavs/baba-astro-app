import 'package:flutter/material.dart';

class HindiSubscriptionScreen extends StatelessWidget {
  final VoidCallback? onClose;

  const HindiSubscriptionScreen({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage: AssetImage("assets/images/ig_logo_jano.png"),
            ),
            SizedBox(width: 4),
            Text(
              "Jano",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              if (onClose != null) onClose!();
              Navigator.of(context).pop();
            },
          ),
          SizedBox(width: 12),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // IMAGE
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.asset(
                      "assets/images/krishna.png",
                      height: 260,
                    ),
                  ),

                  SizedBox(height: 10),

                  // HINDI MAIN TEXT
                  Column(
                    children: [
                      Text(
                        "वेद–पुराण–गीता",
                        style: TextStyle(
                          color: Color(0xFF007BFF),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "का सार और सनातन का राज",
                        style: TextStyle(
                          color: Color(0xFF007BFF),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Sub text
                  Text(
                    "Start Your 1-day trial in just",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),

                  SizedBox(height: 10),

                  // Price
                  Text(
                    "₹1",
                    style: TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007BFF),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Footer Section
          Column(
            children: [
              // Subscription Row
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "then ₹99/month  ",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),

                        Text(
                          "₹999 ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),

                    // Blue tag
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF007BFF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "90% off",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // T&C
              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                  children: [
                    TextSpan(text: "Auto-renews. Cancel anytime. "),
                    TextSpan(
                      text: "T&C apply.",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // BUTTON
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF007BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Start trial now!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}
