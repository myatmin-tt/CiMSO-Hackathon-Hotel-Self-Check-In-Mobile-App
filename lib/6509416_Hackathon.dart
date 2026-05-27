import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FormData(),
      child: SelfCheckInApp(),
    ),
  );
}

class SelfCheckInApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guest Self Check-In',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

// FormData class for state management
class FormData extends ChangeNotifier {
  String username = '';
  String password = '';
  String creditCardNumber = '';
  String errorMessage = '';

  bool isValidForm() {
    if (username.isEmpty || password.isEmpty || creditCardNumber.isEmpty) {
      errorMessage = 'Please fill out all fields.';
      return false;
    }
    if (creditCardNumber.length != 16) {
      errorMessage = 'Please enter a valid 16-digit credit card number.';
      return false;
    }
    errorMessage = '';
    return true;
  }

  void setUsername(String value) {
    username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setCreditCardNumber(String value) {
    creditCardNumber = value;
    notifyListeners();
  }
}

// Login Screen with softer UI
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormData>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.lightBlueAccent,
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) => formData.setUsername(value),
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.lightBlue[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) => formData.setPassword(value),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.lightBlue[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              if (formData.errorMessage.isNotEmpty)
                Text(
                  formData.errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                onPressed: () {
                  if (formData.username.isEmpty || formData.password.isEmpty) {
                    formData.errorMessage = 'Please enter username and password.';
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Main Page with multiple upcoming stays
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check-in'),
        backgroundColor: Colors.lightBlueAccent,
        actions: [IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming Stays', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildStayCard(context, 'The Hotel', 'Mar 27, 2025', 'Mar 30, 2025', 'Hotel details go here.'),
            _buildStayCard(context, 'Beach Resort', 'Apr 10, 2025', 'Apr 15, 2025', 'Resort details go here.'),
            _buildStayCard(context, 'Mountain Lodge', 'May 5, 2025', 'May 10, 2025', 'Lodge details go here.'),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInScreen()));
              },
              child: Text('Complete Check-In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStayCard(BuildContext context, String hotel, String checkIn, String checkOut, String details) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailsPage(
              hotel: hotel,
              checkIn: checkIn,
              checkOut: checkOut,
              details: details,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hotel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in'),
                      Text(checkIn, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Checkout'),
                      Text(checkOut, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

// Booking Details Page
class BookingDetailsPage extends StatelessWidget {
  final String hotel;
  final String checkIn;
  final String checkOut;
  final String details;

  BookingDetailsPage({required this.hotel, required this.checkIn, required this.checkOut, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$hotel Details'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resort Image
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300], // Placeholder color
                  image: DecorationImage(
                    image: AssetImage('assets/resort.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 15),

              // Resort Name
              Text(
                hotel,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Check-in / Checkout Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check-in:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(checkIn, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Checkout:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(checkOut, style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Resort Details
              Text(
                'Resort Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                details,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Additional Amenities
              Text(
                'Amenities:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                '✓ Free WiFi\n✓ Swimming Pool\n✓ Spa & Wellness Center\n✓ 24/7 Room Service\n✓ Beach Access\n✓ Complimentary Breakfast',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Back Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Upcoming Stays'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// Check-In Screen with credit card number input
class CheckInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<FormData>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Self Check-In'), backgroundColor: Colors.lightBlueAccent),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upload Passport & Selfie Photo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () {}, child: Text('Upload')),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) => formData.setCreditCardNumber(value),
              decoration: InputDecoration(
                labelText: 'Credit Card Number',
                prefixIcon: Icon(Icons.credit_card),
                filled: true,
                fillColor: Colors.lightBlue[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.number,
            ),
            if (formData.errorMessage.isNotEmpty)
              Text(formData.errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              onPressed: () {
                if (formData.isValidForm()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThankYouPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(formData.errorMessage)));
                }
              },
              child: Text('Confirm Check-In'),
            ),
          ],
        ),
      ),
    );
  }
}

// Thank You Page after confirming check-in
class ThankYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thank You!'), backgroundColor: Colors.lightBlueAccent),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Thank you for confirming your check-in!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                      (route) => false,
                );
              },
              child: Text('Back to Upcoming Stays'),
            ),
          ],
        ),
      ),
    );
  }
}