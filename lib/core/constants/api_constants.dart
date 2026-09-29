class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://countriesnow.space';
  static const String flagImagesEndpoint = '/api/v0.1/countries/flag/images';
  static const String flagImagesUrl = '$baseUrl$flagImagesEndpoint';

  static const Duration requestTimeout = Duration(seconds: 10);

  static String flagCdnUrl(String iso2) {
    return 'https://flagcdn.com/${iso2.toLowerCase()}.png';
  }
}
