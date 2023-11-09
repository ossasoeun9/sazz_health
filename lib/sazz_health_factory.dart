import 'dart:convert';
import 'package:flutter/services.dart';

import 'number_of_fall_model.dart';

class SazzHealthFactory {
  static const MethodChannel _methodChannel = MethodChannel('sazz_health');

  static Future<bool?> requestAuthorization() => _methodChannel.invokeMethod<bool?>("requestAuthorization");

  static Future<List<NumberOfFallModel>> readNumberOfFallen(
      DateTime fromDate,
      DateTime toDate,
      ) async {
    try {
      var jsonContent = await _methodChannel.invokeMethod<String?>(
        "readNumberOfFallen",
        {
          "fromDate": fromDate.toIso8601String(),
          "toDate": toDate.toIso8601String(),
        },
      );
      if (jsonContent == null) return [];
      List jsonDecoded = json.decode(jsonContent);
      return jsonDecoded.map<NumberOfFallModel>((e) {
        return NumberOfFallModel.fromMap(e);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
