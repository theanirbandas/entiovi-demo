import 'package:dio/dio.dart' hide Headers;
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'predictions.g.dart';

@JsonSerializable()
class PredictionModel {
  final double probability;
  final int prediction;

  PredictionModel({
    required this.probability,
    required this.prediction,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) => _$PredictionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionModelToJson(this);
}

@JsonSerializable()
class Predictions {
  final Map<String, PredictionModel> data;

  Predictions({
    required this.data,
  });

  factory Predictions.fromJson(Map<String, dynamic> json) => _$PredictionsFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionsToJson(this);
}

@JsonSerializable()
class PredictionRequest {
  final double PAT_WT;
  final double MULT_FETUS;
  final double GAGE_US;
  final double MS1_RESULT;
  final double MS1_GEST;
  final double MS1_MATAGE;
  final double HCG1;
  final double EST1;
  final double INHA1;
  final String RPT_GMETH;

  PredictionRequest({
    required this.PAT_WT,
    required this.MULT_FETUS,
    required this.GAGE_US,
    required this.MS1_RESULT,
    required this.MS1_GEST,
    required this.MS1_MATAGE,
    required this.HCG1,
    required this.EST1,
    required this.INHA1,
    required this.RPT_GMETH,
  });

  factory PredictionRequest.fromJson(Map<String, dynamic> json) => _$PredictionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionRequestToJson(this);
}

@RestApi(baseUrl: "https://dev.ideevin.com/tosoh-api")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/prediction")
  @Headers(<String, dynamic>{
    "accept": "application/json",
    "Content-Type": "application/json"
  })
  Future<Predictions> getPrediction(@Body() PredictionRequest request);
}