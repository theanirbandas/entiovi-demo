// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predictions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictionModel _$PredictionModelFromJson(Map<String, dynamic> json) =>
    PredictionModel(
      probability: (json['probability'] as num).toDouble(),
      prediction: (json['prediction'] as num).toInt(),
    );

Map<String, dynamic> _$PredictionModelToJson(PredictionModel instance) =>
    <String, dynamic>{
      'probability': instance.probability,
      'prediction': instance.prediction,
    };

Predictions _$PredictionsFromJson(Map<String, dynamic> json) => Predictions(
      data: (json).map(
        (k, e) =>
            MapEntry(k, PredictionModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$PredictionsToJson(Predictions instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

PredictionRequest _$PredictionRequestFromJson(Map<String, dynamic> json) =>
    PredictionRequest(
      PAT_WT: (json['PAT_WT'] as num).toDouble(),
      MULT_FETUS: (json['MULT_FETUS'] as num).toDouble(),
      GAGE_US: (json['GAGE_US'] as num).toDouble(),
      MS1_RESULT: (json['MS1_RESULT'] as num).toDouble(),
      MS1_GEST: (json['MS1_GEST'] as num).toDouble(),
      MS1_MATAGE: (json['MS1_MATAGE'] as num).toDouble(),
      HCG1: (json['HCG1'] as num).toDouble(),
      EST1: (json['EST1'] as num).toDouble(),
      INHA1: (json['INHA1'] as num).toDouble(),
      RPT_GMETH: json['RPT_GMETH'] as String,
    );

Map<String, dynamic> _$PredictionRequestToJson(PredictionRequest instance) =>
    <String, dynamic>{
      'PAT_WT': instance.PAT_WT,
      'MULT_FETUS': instance.MULT_FETUS,
      'GAGE_US': instance.GAGE_US,
      'MS1_RESULT': instance.MS1_RESULT,
      'MS1_GEST': instance.MS1_GEST,
      'MS1_MATAGE': instance.MS1_MATAGE,
      'HCG1': instance.HCG1,
      'EST1': instance.EST1,
      'INHA1': instance.INHA1,
      'RPT_GMETH': instance.RPT_GMETH,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ApiService implements ApiService {
  _ApiService(
    this._dio, {
    this.baseUrl,
    this.errorLogger,
  }) {
    baseUrl ??= 'https://dev.ideevin.com/tosoh-api';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<Predictions> getPrediction(PredictionRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'accept': 'application/json',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<Predictions>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json',
    )
        .compose(
          _dio.options,
          '/prediction',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Predictions _value;
    try {
      _value = Predictions.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
