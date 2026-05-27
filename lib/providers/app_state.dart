import 'package:flutter/material.dart';
import '../models/booking_model.dart';

class AppState extends ChangeNotifier {
  // ── Auth ──────────────────────────────────────────────────────────────────
  String _username = '';
  String _password = '';
  String _errorMessage = '';
  bool _isLoggedIn = false;
  bool _isLoading = false;

  // ── Check-in form ─────────────────────────────────────────────────────────
  String _creditCardNumber = '';
  String _cardHolderName = '';
  String _cardExpiry = '';
  String _cardCVV = '';
  bool _passportUploaded = false;
  bool _selfieUploaded = false;
  String? _selectedBookingId;

  // ── Getters ───────────────────────────────────────────────────────────────
  String get username => _username;
  String get password => _password;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get creditCardNumber => _creditCardNumber;
  String get cardHolderName => _cardHolderName;
  String get cardExpiry => _cardExpiry;
  String get cardCVV => _cardCVV;
  bool get passportUploaded => _passportUploaded;
  bool get selfieUploaded => _selfieUploaded;
  String? get selectedBookingId => _selectedBookingId;

  // ── Bookings data ─────────────────────────────────────────────────────────
  final List<BookingModel> bookings = [
    BookingModel(
      id: 'BK001',
      hotelName: 'The Grand Palazzo',
      location: 'Maldives, South Asia',
      checkIn: 'Jun 15, 2025',
      checkOut: 'Jun 20, 2025',
      roomType: 'Ocean View Suite',
      pricePerNight: 420.0,
      nights: 5,
      confirmationCode: 'GPM-20250615',
      amenities: [
        'Free WiFi',
        'Private Pool',
        'Spa & Wellness',
        '24/7 Butler',
        'Overwater Bungalow',
        'Complimentary Breakfast',
      ],
    ),
    BookingModel(
      id: 'BK002',
      hotelName: 'Azure Beach Resort',
      location: 'Phuket, Thailand',
      checkIn: 'Jul 10, 2025',
      checkOut: 'Jul 17, 2025',
      roomType: 'Beachfront Villa',
      pricePerNight: 280.0,
      nights: 7,
      confirmationCode: 'ABR-20250710',
      amenities: [
        'Free WiFi',
        'Beachfront Access',
        'Infinity Pool',
        'Water Sports',
        'Restaurant & Bar',
        'Airport Transfer',
      ],
    ),
    BookingModel(
      id: 'BK003',
      hotelName: 'Alpine Summit Lodge',
      location: 'Zermatt, Switzerland',
      checkIn: 'Aug 5, 2025',
      checkOut: 'Aug 12, 2025',
      roomType: 'Mountain Chalet Suite',
      pricePerNight: 350.0,
      nights: 7,
      confirmationCode: 'ASL-20250805',
      amenities: [
        'Free WiFi',
        'Ski-in Ski-out',
        'Heated Indoor Pool',
        'Gourmet Restaurant',
        'Sauna & Steam',
        'Concierge Service',
      ],
    ),
  ];

  BookingModel? getBookingById(String id) {
    try {
      return bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Setters ───────────────────────────────────────────────────────────────
  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setErrorMessage(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void setCreditCardNumber(String value) {
    _creditCardNumber = value;
    notifyListeners();
  }

  void setCardHolderName(String value) {
    _cardHolderName = value;
    notifyListeners();
  }

  void setCardExpiry(String value) {
    _cardExpiry = value;
    notifyListeners();
  }

  void setCardCVV(String value) {
    _cardCVV = value;
    notifyListeners();
  }

  void setSelectedBooking(String id) {
    _selectedBookingId = id;
    notifyListeners();
  }

  void mockUploadPassport() {
    _passportUploaded = true;
    notifyListeners();
  }

  void mockUploadSelfie() {
    _selfieUploaded = true;
    notifyListeners();
  }

  // ── Business logic ────────────────────────────────────────────────────────
  Future<bool> login() async {
    if (_username.isEmpty || _password.isEmpty) {
      setErrorMessage('Please enter your email and password.');
      return false;
    }
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    // Simulate network call
    await Future.delayed(const Duration(milliseconds: 1200));
    _isLoading = false;
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  bool validateCheckIn() {
    if (!_passportUploaded) {
      setErrorMessage('Please upload your passport photo.');
      return false;
    }
    if (!_selfieUploaded) {
      setErrorMessage('Please upload your selfie photo.');
      return false;
    }
    if (_cardHolderName.isEmpty) {
      setErrorMessage('Please enter the card holder name.');
      return false;
    }
    if (_creditCardNumber.replaceAll(' ', '').length != 16) {
      setErrorMessage('Please enter a valid 16-digit credit card number.');
      return false;
    }
    if (_cardExpiry.isEmpty ||
        !RegExp(r'^\d{2}/\d{2}$').hasMatch(_cardExpiry)) {
      setErrorMessage('Please enter a valid expiry date (MM/YY).');
      return false;
    }
    if (_cardCVV.length < 3) {
      setErrorMessage('Please enter a valid CVV.');
      return false;
    }
    _errorMessage = '';
    // Mark selected booking as checked in
    if (_selectedBookingId != null) {
      final booking = getBookingById(_selectedBookingId!);
      if (booking != null) booking.isCheckedIn = true;
    }
    notifyListeners();
    return true;
  }

  void logout() {
    _username = '';
    _password = '';
    _isLoggedIn = false;
    _creditCardNumber = '';
    _cardHolderName = '';
    _cardExpiry = '';
    _cardCVV = '';
    _passportUploaded = false;
    _selfieUploaded = false;
    _errorMessage = '';
    _selectedBookingId = null;
    for (final b in bookings) {
      b.isCheckedIn = false;
    }
    notifyListeners();
  }
}
