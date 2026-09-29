import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/country_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';

abstract class CountriesRemoteDataSource {
  Future<List<CountryModel>> getCountries();
}

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final http.Client client;

  CountriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await client
          .get(
            Uri.parse(ApiConstants.flagImagesUrl),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final error = jsonData['error'] as bool? ?? false;

        if (error) {
          final msg = jsonData['msg'] as String? ?? 'Unknown API error';
          throw ApiException(msg);
        }

        final data = jsonData['data'] as List<dynamic>? ?? [];
        final countries = <CountryModel>[];
        final seenIso2 = <String>{};

        for (final item in data) {
          try {
            final model = CountryModel.fromJson(item as Map<String, dynamic>);
            if (model.isValid && !seenIso2.contains(model.iso2)) {
              seenIso2.add(model.iso2);
              countries.add(model);
            }
          } catch (e) {
            // Skip invalid records
            continue;
          }
        }

        return countries;
      } else {
        throw ServerException(
          'Server returned status code: ${response.statusCode}',
        );
      }
    } on ApiException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw const TimeoutException('Request timed out');
      }
      throw NetworkException('Network error: ${e.toString()}');
    }
  }
}
