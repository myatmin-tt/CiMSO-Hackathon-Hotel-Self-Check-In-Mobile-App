class BookingModel {
  final String id;
  final String hotelName;
  final String location;
  final String checkIn;
  final String checkOut;
  final String roomType;
  final double pricePerNight;
  final int nights;
  final String confirmationCode;
  final List<String> amenities;
  bool isCheckedIn;

  BookingModel({
    required this.id,
    required this.hotelName,
    required this.location,
    required this.checkIn,
    required this.checkOut,
    required this.roomType,
    required this.pricePerNight,
    required this.nights,
    required this.confirmationCode,
    required this.amenities,
    this.isCheckedIn = false,
  });

  double get totalPrice => pricePerNight * nights;
}
