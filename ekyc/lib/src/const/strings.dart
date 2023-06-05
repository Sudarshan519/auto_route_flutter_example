// ignore_for_file: constant_identifier_names

class AppStrings {
  ///
  ///
  static List cards = <String>[
    "Residence Card",
    "Driving License",
    "My Number Card"
  ];
  static const INIT = "EKYC START";
  static const FRONT = "FRONT";
  static const BACK = "BACK";
  static const TILTED = "TILTED";
  static const SELFIE = "SELFIE";
  static const LIVENESS = "BLINK";
  static const String BLINK = "BLINK";
  static const String DOCUMENT_VERIFICATION = "DOCUMENT VERIFICATION SDK";

  static const String BEGIN_PROCESS = "Begin Process";

  static const String RETAKE = "Retake Picture";
  static const String NEXT = "Save and Continue";

  static const String EKYCFORM = "EKYCFORM";

  static const ADDITIONAL_INFORMATION = "ADDITIONAL INFO";

  static const EKYC_START_FORM = "EKYC START FORM";
}

class AppImages {
  static const DOCUMENT_FAIL = "";
  static const DIAGONAL_FAIL = "";
  static const SELFIE_FAIL = "";
}

class TModels {
  static const FRONT_LABEL = "";
  static const BACK_LABEL = "assets/back/labels.txt";
  static const TILTED_LABEL = "assets/tilted/labels.txt";
  static const SELFIE_LABEL = "assets/face_final/labels.txt";
  static const LIVELINESS_LABEL = "assets/eye3/labels.txt";

  static const FRONT_MODEL =
      "packages/flutter_pkg/assets/front_new/model_unquant.tflite";
  static const BACK_MODEL =
      "packages/flutter_pkg/assets/back/model_unquant.tflite"; //'packages/flutter_pkg/assets/back/model_unquant.tflite'
  static const TILTED_MODEL =
      "packages/flutter_pkg/assets/tilted/model_unquant.tflite";
  static const SELFIE_MODEL =
      "packages/flutter_pkg/assets/face_final/model_unquant.tflite";
  static const LIVELINESS_MODEL =
      "packages/flutter_pkg/assets/eye3/model_unquant.tflite";
}
