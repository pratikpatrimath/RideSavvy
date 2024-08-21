class StringConstants {
  static const String currencySymbol = "₹";
  static const String appName = "Ola uber Price Comparison";
  static const String databaseName = "ola_uber_price_comparison.db";
  static const int databaseVersion = 1;

  //API
  static const String googleMapKey = "AIzaSyAhywGgq9Wijf3LMZOLVDAV8lQ8Buf5OK8";
  static const String nameGen = "https://api.namefake.com/indian-indian/male/";

  //ASSET
  static const String loadingLottie = 'asset/loading.json';
  static const String noResultLottie = 'asset/no_result.json';

  static const String logo = 'asset/admin.png';
  static const String signIn = 'asset/sign_in.png';
  static const String noImage = 'asset/no_image.jpeg';
  static const String errorImage = 'asset/no_image.jpeg';

  static const String carMapIcon = 'asset/car_map_icon.png';
  static const String carIcon = 'asset/car.png';
  static const String taxiIcon = 'asset/taxi.png';
  static const String autoIcon = 'asset/auto.png';
  static const String suvIcon = 'asset/suv.png';
  static const String luxuryCarIcon = 'asset/luxury_car.png';
  static const String miniCarIcon = 'asset/mini_car.png';
  static const String gpay = 'asset/gpay.png';

  static const String olaIcon = 'asset/ola.png';
  static const String uberIcon = 'asset/uber.png';

  //DATABASE
  static const String tableUserMaster = "UserMaster";
  static const String userId = "userId";
  static const String name = "name";
  static const String emailId = "emailId";
  static const String password = "password";

  static const String olaService = 'Ola';
  static const String uberService = 'Uber';

  //TAXI
  static const String auto = 'Auto';
  static const String car = 'Car';
  static const String taxi = 'Taxi';
  static const List<String> categoryList = [auto, car, taxi];

  // Ola City Taxi
  static const String olaAuto = 'Auto';
  static const String olaMini = 'Mini';
  static const String olaPrimeSedan = 'Sedan';
  static const String olaPrimeSUV = 'SUV';
  static const String olaLux = 'Lux';
  static const String olaKaaliPeeliTaxi = 'Kaali Peeli Taxi';
  static const List<String> olaVehicleList = [
    olaAuto,
    olaMini,
    olaPrimeSedan,
    olaPrimeSUV,
    olaLux,
    olaKaaliPeeliTaxi,
  ];

  // Uber City Taxi
  static const String uberAuto = 'UberAUTO';
  static const String uberGo = 'UberGo';
  static const String uberX = 'UberX';
  static const String uberXL = 'UberXL';
  static const String uberBlack = 'UberBLACK';
  static const String uberTaxi = 'UberTaxi';
  static const List<String> uberVehicleList = [
    uberAuto,
    uberGo,
    uberX,
    uberXL,
    uberBlack,
    uberTaxi,
  ];

  static const Map<String, List<String>> vehicleNameList = {
    StringConstants.olaAuto: [
      'Tata Nano',
      'Bajaj Qute',
      'Piaggio Ape',
    ],
    StringConstants.olaMini: [
      'Maruti Suzuki Alto',
      'Hyundai Grand i10',
      'Ford Figo',
    ],
    StringConstants.olaPrimeSedan: [
      'Honda City',
      'Toyota Camry',
      'Volkswagen Vento',
    ],
    StringConstants.olaPrimeSUV: [
      'Ford EcoSport',
      'Hyundai Creta',
      'Mahindra XUV500',
    ],
    StringConstants.olaLux: [
      'Mercedes-Benz S-Class',
      'BMW 7 Series',
      'Audi A8',
    ],
    StringConstants.olaKaaliPeeliTaxi: [
      'Premier Padmini',
      'Hindustan Ambassador',
    ],
    StringConstants.uberAuto: [
      'Bajaj RE',
      'TVS King',
      'Piaggio Ape',
    ],
    StringConstants.uberGo: [
      'Maruti Suzuki Swift',
      'Hyundai Elite i20',
      'Toyota Etios',
    ],
    StringConstants.uberX: [
      'Honda Civic',
      'Toyota Corolla',
      'Ford Aspire',
    ],
    StringConstants.uberXL: [
      'Toyota Innova Crysta',
      'Mahindra Marazzo',
      'Honda BR-V',
    ],
    StringConstants.uberBlack: [
      'Mercedes-Benz E-Class',
      'Audi A6',
      'BMW 5 Series',
    ],
    StringConstants.uberTaxi: [
      'Premier Padmini',
      'Hindustan Ambassador',
    ],
  };
}
